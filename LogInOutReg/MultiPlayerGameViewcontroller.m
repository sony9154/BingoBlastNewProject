//
//  MultiPlayerGameViewcontrollerViewController.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/19.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "MultiPlayerGameViewcontroller.h"
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>

typedef enum SendDataType{
    SendDataBlockChecked,
    SendDataScorePenalty,
    SendDataCallNumber,
    SendDataSkillUsed,
    SendDataGameOver
}SendDataType;

@interface MultiPlayerGameViewcontroller ()<GameCenterManagerDelegate>

@end

@implementation MultiPlayerGameViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sound,music,voice access

- (void)loadBGMFile{
    bgmFile = [[NSBundle mainBundle] URLForResource:@"bgm/Battle-resolution" withExtension:@"mp3"];
    [bgmAuthor setText:@"覚悟ができたら掛かってきな!Wingless Seraph"];
}

#pragma mark - player's board access
- (void)blockPressed:(BlockButton *)sender{
    Block* block = [player.board getBlockX:sender.x Y:sender.y];

    if(!block.isChecked){
        int matchIndex = [callNumbers checkNumber:block.number];
        if( matchIndex != -1){
            //block checked
            [self sendDataForBlockCheckInX:sender.x Y:sender.y NumberWithIndex:matchIndex];
        }else{
            //score decrease 50
            [self sendScorePenalty];
        }
    }
    
    [super blockPressed:sender];
}

#pragma mark - called numbers access

- (void) createCallNumber{
    NSArray<GKPlayer*>* players = [GameCenterManager shardManager].match.players;
    NSString* maxPlayerID = @"0";
    for(int n = 0; n < players.count; n++){
        GKPlayer* gkplayer = players[n];
        if([gkplayer.playerID compare:maxPlayerID] == NSOrderedDescending){
            maxPlayerID = gkplayer.playerID;
        }
    }
    if([[GKLocalPlayer localPlayer].playerID compare:maxPlayerID] == NSOrderedDescending)self.isHost = true;
    NSLog(@"ID: %@",[GKLocalPlayer localPlayer].playerID);
    [super createCallNumber];
}

- (void) startCallNumber{
    if(self.isHost){
        [super startCallNumber];
    }
}

- (void) callNewNumber{
    if(callNumbers.allNumbers.count > 0){
        [self sendCalledNumber:[callNumbers getNumber:0]];
    }
    [super callNewNumber];
    if([callNumbers isNoNumber]){
        [self sendDataGameOver];
    }
}

- (void) updateClock{
    if(self.isHost)[clockLabel setText:[NSString stringWithFormat:@"%lu",callNumbers.allNumbers.count]];
}

#pragma mark - skill access

- (void) useSkill{
    
    int selectedSkillIndex = -1;
    
    //get index of selected skill
    for (int n = 0; n < SKILL_COUNT; n++) {
        if(skillButtons[n].isSelected && player.skillDatas[n].power >= SKILL_MAX_POWER){
            selectedSkillIndex = n;
            break;
        }
    }
    
    [super useSkill];
    
    if(selectedSkillIndex == -1)return;
    [self sendSkillUsedWithSkillID:selectedSkillIndex];
    
}


#pragma mark - game over access

- (IBAction)surrender:(id)sender{
    
    [super surrender:sender];
    [self sendDataGameOver];
    
}

#pragma mark - GameCenterManagerDelegate


- (void) matchStarted{
    
}
- (void) matchEnded{
    
}

#pragma mark - receive data

- (void) match:(GKMatch*)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer*)player{
    NSDictionary* dataDic = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    SendDataType sendDataType = [dataDic objectForKey:@"type"];
    SendDataType sendDataType = [dataDic[@"type"] intValue];
    switch (sendDataType) {
        case SendDataBlockChecked:
            [self opponentCheckBlockWith:dataDic[@"content"]];
            break;
        case SendDataScorePenalty:
            opponent.penalty +=50;
            [self updateScore];
            break;
        case SendDataCallNumber:
            [callNumbers turnNumbersWithNewNumber:[dataDic[@"content"] intValue]];
            [self updateCallNumbers];
            int remainNumbersCount = [clockLabel.text intValue] - 1;
            [clockLabel setText:[NSString stringWithFormat:@"%i",remainNumbersCount]];
            break;
        case SendDataSkillUsed:
            [self opponentSkillUsedWith:dataDic[@"content"]];
            break;
        case SendDataGameOver:
            opponent.isSurrender = [dataDic[@"content"] boolValue];
            [self gameOver];
            break;
            
        default:
            break;
    }
}

- (void)opponentCheckBlockWith:(NSDictionary*)coordinateAndIndexDic{
    
    int x = [(NSNumber*)coordinateAndIndexDic[@"x"] intValue];
    int y = [(NSNumber*)coordinateAndIndexDic[@"y"] intValue];
    Block* block = [opponent.board getBlockX:x Y:y];
    block.isChecked = true;
    int index = [(NSNumber*)coordinateAndIndexDic[@"index"] intValue];
    [callNumbers setNumberWithIndex:index to:-1];
    
    [self drawOpponentBoard];
    [self updateScore];
}

- (void)opponentSkillUsedWith:(NSDictionary*)skillIDAndEffectCoordinatesDic{
    
    int skillID = [skillIDAndEffectCoordinatesDic[@"skillID"] intValue];
    NSMutableArray<NSDictionary*>* effectCoordinates = skillIDAndEffectCoordinatesDic[@"effectedCoordinates"];
    
    
    StateData* stateData;
    Board* effectedBoard;
    if(skills[skillID].isTargetOpponent){
        stateData = player.stateDatas[skillID];
        effectedBoard = player.board;
    }else{
        stateData = opponent.stateDatas[skillID];
        effectedBoard = opponent.board;
    }
    
    stateData.isRemain = true;
    
    switch (skillID) {
        case SkillIDDestroy:
            
            stateData.remainTime = STATE_DESTROY_DURATION;
            
            for (NSDictionary* coordinate in effectCoordinates) {
                
                int x = [coordinate[@"x"] intValue];
                int y = [coordinate[@"y"] intValue];
                Block* effectedBlock = [effectedBoard getBlockX:x Y:y];
                effectedBlock.isChecked = false;
                effectedBlock.isDestroyed = true;
                
            }
            
            break;
        
        case SkillIDSeal:
            
            stateData.remainTime = STATE_SEAL_DURATION;
            
            for (NSDictionary* coordinate in effectCoordinates) {
                
                int x = [coordinate[@"x"] intValue];
                int y = [coordinate[@"y"] intValue];
                Block* effectedBlock = [effectedBoard getBlockX:x Y:y];
                effectedBlock.isSealed = true;
                
            }
        
            break;
        case SkillIDAid:
            
            stateData.remainTime = STATE_AID_DURATION;
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - send data

- (void) sendDataForBlockCheckInX:(int)x Y:(int)y NumberWithIndex:(int)index{
    NSDictionary* coordinateAndIndexDic = @{@"x":[NSNumber numberWithInt:x],@"y":[NSNumber numberWithInt:y],@"index":[NSNumber numberWithInt:index]};
    NSDictionary* dataDic = @{@"type":[NSNumber numberWithInt:SendDataBlockChecked],@"content":coordinateAndIndexDic};
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    [self sendData:data];
}

- (void) sendScorePenalty{
    NSDictionary* dataDic = @{@"type":[NSNumber numberWithInt:SendDataScorePenalty]};
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    [self sendData:data];
    
}

- (void) sendCalledNumber:(int)number{
    
    NSDictionary* dataDic = @{@"type":[NSNumber numberWithInt:SendDataCallNumber],
                              @"content":[NSNumber numberWithInt:number]};
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    [self sendData:data];
    
}

- (void) sendSkillUsedWithSkillID:(int)skillID{
    
    NSMutableArray* effectCoordinates = [[NSMutableArray alloc] init];
    
    Board* effectedBoard;
    
    if(skills[skillID].isTargetOpponent){
        effectedBoard = opponent.board;
    }else{
        effectedBoard = player.board;
    }
    
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
            Block* block = [effectedBoard getBlockX:x Y:y];
            BOOL isEffected = false;
            switch (skillID) {
                case SkillIDDestroy:
                    isEffected = block.isDestroyed;
                    break;
                case SkillIDSeal:
                    isEffected = block.isSealed;
                    break;
                case SkillIDAid:
                    //The skill doesn't target coordinates.
                    break;
                    
                default:
                    break;
            }
            
            if(isEffected){
                NSDictionary* coordinate = @{@"x":[NSNumber numberWithInt:x],@"y":[NSNumber numberWithInt:y]};
                [effectCoordinates addObject:coordinate];
            }
            
        }
    }
    
    NSDictionary* skillIdAndEffectCoordinatesDic = @{@"skillID":[NSNumber numberWithInt:skillID],@"effectedCoordinates":effectCoordinates};
    
    NSDictionary* dataDic = @{@"type":[NSNumber numberWithInt:SendDataSkillUsed],
                              @"content":skillIdAndEffectCoordinatesDic};
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    
    [self sendData:data];
    
}

- (void) sendDataGameOver{
    
    // Send gameover message. Content is if player surrender.
    NSDictionary* dataDic = @{@"type":[NSNumber numberWithInt:SendDataGameOver],@"content":[NSNumber numberWithBool:player.isSurrender]};
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    [self sendData:data];
}

- (void) sendData:(NSData*)data{
    NSError* error;
    [[GameCenterManager shardManager].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
}
//-(void) sendNumber: (NSString*)passString {
//    
//    NSData * data = [passString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError * error;
//    [self.gameMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
//    self.playLabel.text = @"Send Number";
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
