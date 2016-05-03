//
//  Player.m
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype) initWithName:(NSString*)name Photo:(NSString*)photoPath{
    
    self = [super init];
    if(self) {
        self.name = name;
        self.photoPath = photoPath;
        self.board = [[Board alloc] init];
        self.score = 0;
        self.penalty = 0;
        [self createSkillDatas];
        [self createStateDatas];
    }
    return self;
    
}


- (int) caculateScore{
    
    int newScore = 0;
    
    newScore = (int)self.board.lines.count * 300;
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
            if([self.board getBlockX:x Y:y].isChecked)newScore += 100;
        }
    }
    
    newScore -= self.penalty;
    
    self.score = newScore;
    
    return newScore;
    
}

-(void)createSkillDatas{
    
    self.skillDatas = [[NSMutableArray<SkillData*> alloc] init];
    for(int n = 0; n < SKILL_COUNT; n++){
        
        [self.skillDatas addObject:[[SkillData alloc] initWithID:n]];
        
    }
    
}

-(void)createStateDatas{
    
    self.stateDatas = [[NSMutableArray<StateData*> alloc] init];
    for (int n = 0; n < STATE_COUNT; n++) {
        
        [self.stateDatas addObject:[[StateData alloc] initWithID:n]];
        
    }
    
    
}

//
//-(void)createSkills{
//    
//    self.skills = [[NSMutableArray alloc] init];
//    
//    [self.skills addObject:[[SkillDestroy alloc] init]];
//    [self.skills addObject:[[SkillSeal alloc] init]];
//    [self.skills addObject:[[SkillAid alloc] init]];
//    
//    
//}

@end
