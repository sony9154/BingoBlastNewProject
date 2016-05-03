//
//  ViewController.m
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundColor"]]];
    
    [self setBackgroundOfView:self.view WithImageNamed:@"BackgroundColor"];
    
    isOver = false;
    
    [self createClock];
    [self.view bringSubviewToFront:scoreLabel];
    [self.view bringSubviewToFront:opponentScoreLabel];
    
    player = [[Player alloc] initWithName:@"tempName" Photo:@"tempPath"];
    [self createBoard];
    
    opponent = [[Player alloc] initWithName:@"tempName" Photo:@"tempPath"];
    [self createOpponentBoard];

    [self createCallNumber];
    
    [self createSkills];
    [self createSkillOperatingArea];
    
    [self createStates];
    
    [self playBgm];

}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sound,music,voice access

- (void) playBgm{
    
    NSURL* bgmFile = [[NSBundle mainBundle] URLForResource:@"bgm/kouchanojikan" withExtension:@"mp3"];
    bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgmFile error:nil];
    bgmPlayer.numberOfLoops = -1;
    [bgmPlayer play];
    [self.view bringSubviewToFront:bgmAuthor];
//    [self.view bringSubviewToFront:bgmAuthorWeb];
    
}

- (IBAction) muteButtonPressed:(id)sender {
    
    UIButton* muteButton = (UIButton*)sender;
    if(isMuted){
        [bgmPlayer setVolume:1.0];
        [blockClickedSoundPlayer setVolume:1.0];
        [muteButton setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
    }
    else{
        [bgmPlayer setVolume:0.0];
        [blockClickedSoundPlayer setVolume:0.0];
        [muteButton setImage:[UIImage imageNamed:@"muteVolume"] forState:UIControlStateNormal];
    }
    
    isMuted = !isMuted;
       
}

#pragma mark - count down time

- (void) createClock{
    
    CGSize screenSize = self.view.frame.size;
    CGRect clockRect = CGRectMake(0, 0, screenSize.width * 104.0/320.0, screenSize.height * 103.0/568.0);
    
    clockView = [[UIView alloc] initWithFrame:clockRect];
    [self setBackgroundOfView:clockView WithImage:[UIImage imageNamed:@"timeClock"]];
    [self.view addSubview:clockView];
    
}

#pragma mark - player's board access

- (void) createBoard{
    
//    board = [[Board alloc]init];
    
    CGSize screenSize = self.view.frame.size;
    //    CGRect boardViewFrame = CGRectMake(0, screenSize.height - screenSize.width, screenSize.width, screenSize.width);
    CGRect boardViewFrame = CGRectMake(0, screenSize.height / 2, screenSize.width, screenSize.height / 2);
    
    boardView = [[UIView alloc] initWithFrame:boardViewFrame];
    
//    int block_width = boardView.frame.size.width/LINE_LENGTH;
    CGRect boardInsideRect = CGRectMake(screenSize.width * 5.0/320.0 - boardViewFrame.origin.x , screenSize.height * 289.0/568.0 - boardViewFrame.origin.y, screenSize.width * 310.0/320.0, screenSize.height * 274.0/568.0);
    int block_width = boardInsideRect.size.width/LINE_LENGTH;
    int block_height = boardInsideRect.size.height/LINE_LENGTH;
    //create button
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
//                        CGRect blockButtonRect = CGRectMake(x * block_width + block_width * 0.05, y * block_width + block_width * 0.05, block_width * 0.9, block_width * 0.9);
            CGRect blockButtonRect = CGRectMake(boardInsideRect.origin.x + x * block_width + block_width * 0.05, boardInsideRect.origin.y + y * block_height + block_height * 0.05, block_width * 0.9, block_height * 0.9);
            blockButtons[x][y] = [[BlockButton alloc] initWithFrame:blockButtonRect X:x Y:y];
            BlockButton* blockButton = blockButtons[x][y];
            Block* block = [player.board getBlockX:x Y:y];
            NSString* blockBackgroundImageName = @"";
            switch (block.attribute) {
                case BlockAttributeDestroy:
                    blockBackgroundImageName = @"NumbersAtBingo_Destory";
                    break;
                    
                case BlockAttributeSeal:
                    blockBackgroundImageName = @"NumbersAtBingo_Seal";
                    break;
                    
                case BlockAttributeAid:
                    blockBackgroundImageName = @"NumbersAtBingo_Aid";
                    break;
                    
                default:
                    break;
            }
            
            [self setBackgroundOfView:blockButton WithImageNamed:blockBackgroundImageName];
            [blockButton setTitle:[NSString stringWithFormat:@"%i",block.number] forState:UIControlStateNormal];
            [blockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [blockButton addTarget:self action:@selector(blockPressed:) forControlEvents:UIControlEventTouchUpInside];
            [boardView addSubview:blockButton];
        }
    }
    
    //clear background color
//    [boardView setBackgroundColor:nil];
    [self setBackgroundOfView:boardView WithImageNamed:@"BingoNumberBackground"];
    [self.view addSubview:boardView];
    
    //add drawBoardView
    drawBoardView = [[UIImageView alloc] initWithFrame:boardViewFrame];
    [drawBoardView setAlpha:0.5];
//    [drawBoardView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:drawBoardView];
//    [self.view bringSubviewToFront:drawBoardView];

}

- (void) blockPressed:(BlockButton*)sender{
    
    if(isOver)return;
    NSURL* blockClickedSoundFile = nil;
    Block* block = [player.board getBlockX:sender.x Y:sender.y];
    if(block.isSealed){
        blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/stupid3" withExtension:@"mp3"];
    }
    else if(block.isChecked){
        blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/decision22" withExtension:@"mp3"];
    }else{
        int matchIndex = [callNumbers checkNumber:block.number];
        if( matchIndex != -1){
            [callNumbers setNumberWithIndex:matchIndex to:-1];
            block.isChecked = true;
            SkillData* skillData = player.skillDatas[block.attribute];
            skillData.power = skillData.power < SKILL_MAX_POWER ? skillData.power + 1 : SKILL_MAX_POWER;
//            Skill* skill =(Skill*)player.skills[block.attribute];
//            skill.power = skill.power < SKILL_MAX_POWER ? skill.power + 1 : SKILL_MAX_POWER;
            blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/decision3" withExtension:@"mp3"];
        }else{
            player.penalty += 50;
            blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/cancel5" withExtension:@"mp3"];
        }
    }
    if(!isMuted){
        blockClickedSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blockClickedSoundFile error:nil];
        [blockClickedSoundPlayer play];
    }
    
    [self updateGame];
    
    //for test
    //[self skillSpecialEffect];
    
}

- (void) drawBoard{
    
    NSMutableArray* lines = [player.board checkLines];
    
    UIGraphicsBeginImageContext(drawBoardView.frame.size);
//    int block_width = boardView.frame.size.width/LINE_LENGTH;
    
    CGSize screenSize = self.view.frame.size;
    CGRect boardViewFrame = boardView.frame;
    
    CGRect boardInsideRect = CGRectMake(screenSize.width * 5.0/320.0 - boardViewFrame.origin.x , screenSize.height * 289.0/568.0 - boardViewFrame.origin.y, screenSize.width * 310.0/320.0, screenSize.height * 274.0/568.0);
    int block_width = boardInsideRect.size.width/LINE_LENGTH;
    int block_height = boardInsideRect.size.height/LINE_LENGTH;
    
    for(int n = 0; n < lines.count; n++){
        
        CGFloat start_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.x * block_width;
        CGFloat start_y = block_height/2 + ((Line*)[lines objectAtIndex:n]).startPoint.y * block_height;
        CGFloat end_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.x * block_width;
        CGFloat end_y = block_height/2 + ((Line*)[lines objectAtIndex:n]).endPoint.y * block_height;
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start_x, start_y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end_x, end_y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0f);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    drawBoardView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}

#pragma mark - opponent's board access

- (void) createOpponentBoard{
    
//    int selfViewFrameHeight = self.view.frame.size.height;
//    int selfViewFrameWidth = self.view.frame.size.width;
//    CGRect drawOpponentBoardViewFrame = CGRectMake(selfViewFrameWidth *(LINE_LENGTH-1)/LINE_LENGTH, selfViewFrameHeight -selfViewFrameWidth * (1 + (double)2/LINE_LENGTH), selfViewFrameWidth / LINE_LENGTH, selfViewFrameWidth / LINE_LENGTH);
    CGSize screenSize = self.view.frame.size;
    CGRect drawOpponentBoardViewFrame = CGRectMake(screenSize.width * 226.0/320.0, screenSize.height * 49.0/568.0, screenSize.width * 88.0/320.0, screenSize.height * 88.0/568.0);
    drawOpponentBoardView = [[UIImageView alloc] initWithFrame:drawOpponentBoardViewFrame];
    [drawOpponentBoardView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:242.0/255.0 blue:255.0/255.0 alpha:0.5]];
    [self.view addSubview:drawOpponentBoardView];
    [self.view bringSubviewToFront:drawOpponentBoardView];
    
}

- (void) drawOpponentBoard{
    
    NSMutableArray* lines = [opponent.board checkLines];
    
    UIGraphicsBeginImageContext(drawOpponentBoardView.frame.size);
    int block_width = round(drawOpponentBoardView.frame.size.width / LINE_LENGTH);
    
    //draw blocks
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0;x < LINE_LENGTH; x++){
            
            Block* block = [opponent.board getBlockX:x Y:y];
            
            if(block.isSealed){
                if(block.isChecked)CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 200.0/255.0, 200.0/255.0, 200.0/255, 1.0);
                else CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 153.0/255.0, 153.0/255.0, 153.0/255, 1.0);
                
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(x * block_width, y * block_width, block_width, block_width));
                
            }else if(block.isChecked){
                
                CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 255.0/255.0, 255.0/255.0, 255.0/255, 1.0);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(x * block_width, y * block_width, block_width, block_width));

                
            }            
        }
    }
    
    //draw lines
    for(int n = 0; n < lines.count; n++){
        
        CGFloat start_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.x * block_width;
        CGFloat start_y = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.y * block_width;
        CGFloat end_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.x * block_width;
        CGFloat end_y = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.y * block_width;
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start_x, start_y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end_x, end_y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0f);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    drawOpponentBoardView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}

#pragma mark - called numbers access

- (void) createCallNumber{
    
    callNumbers = [[CallNumbers alloc] init];
    CGSize screenSize = self.view.frame.size;
//    CGRect callNumberViewFrame = CGRectMake(0, screenSize.height - screenSize.width - screenSize.width * 1/CALL_NUMBER_COUNT, screenSize.width, screenSize.width * 1/CALL_NUMBER_COUNT);
    CGRect callNumberViewFrame = CGRectMake(screenSize.width * 8.0/320.0, screenSize.height * 139.45/568, screenSize.width * 290.0/320.0, screenSize.height * 64.11/568);
    callNumberView = [[UIView alloc] initWithFrame:callNumberViewFrame];
    
    int callNumberLabelWidth = callNumberViewFrame.size.width/CALL_NUMBER_COUNT;
    int callNumberLabelHeight = callNumberViewFrame.size.height;
    
    for(int n = 0; n < CALL_NUMBER_COUNT; n++){
        CGRect callNumberFrame = CGRectMake(n * callNumberLabelWidth, 0, callNumberLabelWidth * 133.0/115.0, callNumberLabelHeight * 133.0/115.0);
        callNumberLabels[n] = [[UILabel alloc] initWithFrame:callNumberFrame];
        UILabel* callNumberLabel = callNumberLabels[n];
        if([callNumbers getNumber:n] != -1){
        
            [self setBackgroundOfView:callNumberLabel WithImageNamed:@"CurrentNumber"];
            NSString* callNumberString = [NSString stringWithFormat:@"%i",[callNumbers getNumber:n]];
            [callNumberLabel setText:callNumberString];
        }//        [callNumberLabel setBackgroundColor:[UIColor yellowColor]];
        callNumberLabel.textAlignment = NSTextAlignmentCenter;
        [callNumberView addSubview:callNumberLabel];
    }
    
    
    [self setBackgroundOfView:callNumberView WithImageNamed:@"Combined Shape"];
//    [callNumberView setBackgroundColor:[UIColor blueColor]];
    [callNumberView setAlpha:0.5];
    [self.view addSubview:callNumberView];
//    [self.view bringSubviewToFront:callNumberView];
    
    [self startCallNumber];
    
}

- (void) startCallNumber{
    
    callNumberTimer = [NSTimer scheduledTimerWithTimeInterval:CALL_NUMBER_TIME_INTERVAL target:self selector:@selector(callNewNumber) userInfo:nil repeats:YES];
    
}

- (void) callNewNumber{
    
    [callNumbers turnNumbers];
    [self updateCallNumbers];
    if([callNumbers isNoNumber]){
        [self gameOver];
    }
    
}

#pragma mark - skill access

- (void) createSkills{
    
    skills = [[NSMutableArray<Skill*> alloc] init];
    [skills addObject:[[SkillDestroy alloc] init]];
    [skills addObject:[[SkillSeal alloc] init]];
    [skills addObject:[[SkillAid alloc] init]];
    
}

- (void) createSkillOperatingArea{
    
    CGSize screenSize = self.view.frame.size;
    
    skillButtons = [[NSMutableArray alloc] init];
    float skillButtonOrigin_x = screenSize.width * 94.0 /320.0;
    float skillButtonOffset = screenSize.width * 49.0 / 320.0;
    
    for(int n = 0; n < SKILL_COUNT; n++){
        
        CGRect skillSelectButtonFrame = CGRectMake(skillButtonOrigin_x + skillButtonOffset * n, screenSize.height * 204.0/568.0, screenSize.width * 35/320, screenSize.height * 35/568);
        SkillButton* skillButton = [[SkillButton alloc] initWithFrame:skillSelectButtonFrame];
//        [self setBackgroundOfView:skillSelectButton WithImageNamed:[NSString stringWithFormat:@"SkillSelectButton_%@",((Skill*)[player.skills objectAtIndex:n]).name]];
//        UIImage* skillSelectButtonImage = [self modifySkillButtonImage:[UIImage imageNamed:@"SkillSelectButton_Destroy"] WithPowerRate:0.6];
//        [self setBackgroundOfView:skillSelectButton WithImage:skillSelectButtonImage];
        
        [skillButton addTarget:self action:@selector(skillButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [skillButtons addObject:skillButton];
        [self.view addSubview:skillButton];
        
    }
    
    CGRect skillActionBarFrame = CGRectMake(screenSize.width * 40.0/320.0, screenSize.height * 239.0/568.0, screenSize.width * 240.0/320.0, screenSize.height * 45.21/568.0);
    skillActionBar = [[UIView alloc] initWithFrame:skillActionBarFrame];
    
    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(useSkill)];
    [skillActionBar addGestureRecognizer:swipeGestureRecognizer];
    
    [self setBackgroundOfView:skillActionBar WithImageNamed:@"SkillAction_Default"];
    
    [self.view addSubview:skillActionBar];
    
}

- (void) skillButtonPressed:(SkillButton*)sender{
    
    for (int n = 0; n < SKILL_COUNT; n++) {
        ((SkillButton*)skillButtons[n]).isSelected = false;
    }
    sender.isSelected = true;
    [self updateSkillOperationArea];
    
    
    
    //just test
//    [self useSkill:player.skills[0]];
    
}

- (void) useSkill{
    
    int selectedSkillIndex = -1;
    
    //get index of selected skill
    for (int n = 0; n < SKILL_COUNT; n++) {
        if(skillButtons[n].isSelected && player.skillDatas[n].power >= SKILL_MAX_POWER){
            selectedSkillIndex = n;
            break;
        }
    }
    //index out of array of skills
    if(selectedSkillIndex < 0 || selectedSkillIndex >= SKILL_COUNT)return;
    
    //use skill and set power of skill to 0
    Skill* skill = skills[selectedSkillIndex];
    SkillData* skillData = player.skillDatas[selectedSkillIndex];
    if(skill.isTargetOpponent){
        [skill effectTo:opponent];
    }else{
        [skill effectTo:player];
    }
    skillData.power = 0;
    
    //[self skillSpecialEffect];
    
    [self updateGame];
    
}

- (void) skillSpecialEffect{
    NSLog(@"skillSpecialEffect");
    isPlayingAnimation = true;
    
    NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoop:) object:nil];
    [thread start];
    [self performSelector:@selector(playAnimation) onThread:thread withObject:nil waitUntilDone:false];
    [NSThread sleepForTimeInterval:1];
    
    
}

- (void) playAnimation{
    NSLog(@"playAnimation");
    [UIView animateWithDuration:10 animations:^{
        
    }];
    
    isPlayingAnimation = false;
    
}

- (void) runLoop:(id)param{
    NSLog(@"runLoop");
    @autoreleasepool {
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        while(isPlayingAnimation){
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    
}

#pragma mark - state access

- (void) createStates{
    
    states = [[NSMutableArray<State*> alloc] init];
    [states addObject:[[StateDestroy alloc]init]];
    [states addObject:[[StateSeal alloc]init]];
    [states addObject:[[StateAid alloc]init]];
    
    stateAccessTimer = [NSTimer scheduledTimerWithTimeInterval:STATE_ACCESS_INTERVAL target:self selector:@selector(accessState) userInfo:nil repeats:true];
    
}

- (void) accessState{
    
    for (int n = 0; n < STATE_COUNT; n++) {
        
        StateData* stateData = player.stateDatas[n];
        State* state = states[n];
        if(stateData.isRemain){
            
            stateData.remainTime -= STATE_ACCESS_INTERVAL;
            if(stateData.remainTime <= 0){
                stateData.isRemain = false;
                [state remove:player];
            }
            
        }
        
    }
    
    
    
    for (int n = 0; n < STATE_COUNT; n++) {
        
        StateData* stateData = opponent.stateDatas[n];
        State* state = states[n];
        if(stateData.isRemain){
            
            stateData.remainTime -= STATE_ACCESS_INTERVAL;
            if(stateData.remainTime <= 0){
                stateData.isRemain = false;
                [state remove:opponent];
                [self updateGame];
            }
            
        }
        
    }
    
    [self updateGame];
    
}

#pragma mark - game update

- (void) updateScore{
    
    [scoreLabel setText:[NSString stringWithFormat:@"score:%i",[player caculateScore]]];
    [opponentScoreLabel setText:[NSString stringWithFormat:@"opponent:%i",[opponent caculateScore]]];
}

- (void) updateBoard{
    
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
            BlockButton* blockButton = blockButtons[x][y];
            Block* block = [player.board getBlockX:x Y:y];
                NSString* blockBackgroundImageName = @"";
            if(block.isSealed){
                if(block.isChecked)blockBackgroundImageName = @"NumbersAtBingo_Checked_Sealed";
                else blockBackgroundImageName = @"NumbersAtBingo_Sealed";
            }
            else if(block.isChecked){
                switch (block.attribute) {
                    case BlockAttributeDestroy:
                        blockBackgroundImageName = @"NumbersAtBingo_Destory_Checked";
                        break;
                        
                    case BlockAttributeSeal:
                        blockBackgroundImageName = @"NumbersAtBingo_Seal_Checked";
                        break;
                        
                    case BlockAttributeAid:
                        blockBackgroundImageName = @"NumbersAtBingo_Aid_Checked";
                        break;
                        
                    default:
                        break;
                }
            }
//            else if([player.board getBlockX:x Y:y].isUnvalid)[blockButton setBackgroundColor:[UIColor redColor]];
            else{
                
                switch (block.attribute) {
                    case BlockAttributeDestroy:
                        blockBackgroundImageName = @"NumbersAtBingo_Destory";
                        break;
                        
                    case BlockAttributeSeal:
                        blockBackgroundImageName = @"NumbersAtBingo_Seal";
                        break;
                        
                    case BlockAttributeAid:
                        blockBackgroundImageName = @"NumbersAtBingo_Aid";
                        break;
                        
                    default:
                        break;
                }
            }
            
            UIImage* blockButtonImage = [UIImage imageNamed:blockBackgroundImageName];
            
            if (player.stateDatas[2].isRemain) {
                
                if([callNumbers checkNumber:block.number] != -1){
                    blockButtonImage = [self combineImage:blockButtonImage WithImage:[UIImage imageNamed:@"AidBorder"]];
                }
                
            }
            
            [self setBackgroundOfView:blockButton WithImage:blockButtonImage];
//            [self setBackgroundOfView:blockButton WithImageNamed:blockBackgroundImageName];
            [blockButton setTitle:[NSString stringWithFormat:@"%i",[player.board getBlockX:x Y:y].number] forState:UIControlStateNormal];
        }
    }
    
    
    

}

- (void) updateCallNumbers{
    
    for(int n = 0; n < CALL_NUMBER_COUNT; n++){
        UILabel* callNumberLabel = callNumberLabels[n];
        NSString* callNumberString = @"";
        if([callNumbers getNumber:n] != -1){
            callNumberString = [NSString stringWithFormat:@"%i",[callNumbers getNumber:n]];
            [self setBackgroundOfView:callNumberLabel WithImageNamed:@"CurrentNumber"];
        }else{
            [callNumberLabel setBackgroundColor:[UIColor clearColor]];
        }
            [callNumberLabel setText:callNumberString];
    }
    
}

- (void) updateSkillOperationArea{
    
    NSString* skillButtonImageName = @"";
    UIImage* skillButtonImage = nil;
    NSString* skillActionImageName = @"";
    UIImage* skillActionImage = nil;
    int selectedSkillButtonIndex = -1;
    for(int n = 0; n < SKILL_COUNT; n++){
        SkillButton* skillButton = skillButtons[n];
        Skill* skill = skills[n];
        SkillData* skillData = player.skillDatas[n];
        if(skillData.power == SKILL_MAX_POWER){
            if(skillButton.isSelected){
                skillButtonImageName = [NSString stringWithFormat:@"SkillButton_%@_Selected",skill.name];
                skillButtonImage = [UIImage imageNamed:skillButtonImageName];
                
                selectedSkillButtonIndex = n;
                
            }else{
                skillButtonImageName = [NSString stringWithFormat:@"SkillButton_%@_Full",skill.name];
                skillButtonImage = [UIImage imageNamed:skillButtonImageName];
            }
        }else{
            skillButtonImageName = [NSString stringWithFormat:@"SkillButton_%@",skill.name];
            float powerRate = (float)skillData.power/SKILL_MAX_POWER;
            skillButtonImage = [self modifySkillButtonImage:[UIImage imageNamed:skillButtonImageName] WithPowerRate:powerRate];
            
        }
        [skillButton setImage:skillButtonImage forState:UIControlStateNormal];
        
    }
    
    if(selectedSkillButtonIndex != -1){
        skillActionImageName = [NSString stringWithFormat:@"SkillAction_%@",((Skill*)skills[selectedSkillButtonIndex]).name];
        skillActionImage = [UIImage imageNamed:skillActionImageName];
//        [self setBackgroundOfView:skillButton WithImage:skillButtonImage];
    }else{
        skillActionImageName = @"SkillAction_Default";
        skillActionImage = [UIImage imageNamed:skillActionImageName];
    }
            
    [self setBackgroundOfView:skillActionBar WithImage:[UIImage imageNamed:skillActionImageName]];
    
}

- (void) updateGame{
    
    //must before updateScore
    [self updateBoard];
    [self updateScore];
    [self updateCallNumbers];
    [self updateSkillOperationArea];
    [self drawBoard];
    [self drawOpponentBoard];
    
}

#pragma mark - game over access

- (void) gameOver{
    
    [callNumberTimer invalidate];
    callNumberTimer = nil;
    [stateAccessTimer invalidate];
    stateAccessTimer = nil;
    
    bgmPlayer = nil;
    blockClickedSoundPlayer = nil;
    
    //UIView makes buttons under it unable to be pressed,but UIImage doesn't.
    UIView* gameOverView = [[UIView alloc] initWithFrame:self.view.frame];
    [gameOverView setBackgroundColor:[UIColor blackColor]];
    [gameOverView setAlpha:0.85];
    
    CGRect selfViewFrame = self.view.frame;
    int lineHeight = selfViewFrame.size.height * 0.05;
    int displayTop = (selfViewFrame.size.height - lineHeight * 3) / 2;
    
    UILabel* finalScoreLabel = [[UILabel alloc] init];
    [finalScoreLabel setText:[NSString stringWithFormat:@"你的分數：%i",[player caculateScore]]];
    finalScoreLabel.font = [finalScoreLabel.font fontWithSize:lineHeight];
    [finalScoreLabel setTextColor:[UIColor whiteColor]];
    [finalScoreLabel setShadowColor:[UIColor blackColor]];
    [finalScoreLabel sizeToFit];
    
    CGRect finalScoreLabelFrame = CGRectMake((selfViewFrame.size.width - finalScoreLabel.frame.size.width)/2, displayTop, finalScoreLabel.frame.size.width, finalScoreLabel.frame.size.height);
    finalScoreLabel.frame = finalScoreLabelFrame;
    
    UILabel* finalOpponentScoreLabel = [[UILabel alloc] init];
    [finalOpponentScoreLabel setText:[NSString stringWithFormat:@"對手的分數：%i",[opponent caculateScore]]];
    finalOpponentScoreLabel.font = [finalOpponentScoreLabel.font fontWithSize:lineHeight];
    [finalOpponentScoreLabel setTextColor:[UIColor whiteColor]];
    [finalOpponentScoreLabel setShadowColor:[UIColor blackColor]];
    [finalOpponentScoreLabel sizeToFit];

    
    CGRect finalOpponentScoreLabelFrame = CGRectMake((selfViewFrame.size.width - finalOpponentScoreLabel.frame.size.width)/2, displayTop + lineHeight, finalOpponentScoreLabel.frame.size.width , finalOpponentScoreLabel.frame.size.height);
    finalOpponentScoreLabel.frame = finalOpponentScoreLabelFrame;
    
    //button used to back to menu
    UIButton* backButton = [[UIButton alloc] init];
    [backButton setTitle:@"回選單" forState:UIControlStateNormal];
    backButton.titleLabel.font = [backButton.titleLabel.font fontWithSize:lineHeight];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.frame = CGRectMake((selfViewFrame.size.width - backButton.frame.size.width)/2, displayTop + lineHeight * 2, backButton.frame.size.width, backButton.frame.size.height);
    
    [self.view addSubview:gameOverView];
    [self.view addSubview:finalScoreLabel];
    [self.view addSubview:finalOpponentScoreLabel];
    [self.view addSubview:backButton];
    
}

- (void) backToMenu:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - screen access

-(bool) shouldAutorotate{
    return false;
}

-(BOOL) prefersStatusBarHidden{
    return true;
}

#pragma mark - access images

- (UIImage*) combineImage:(UIImage*)image1 WithImage:(UIImage*)image2{
    
    UIGraphicsBeginImageContext(image1.size);
    CGRect imageRect = CGRectMake(0, 0, image1.size.width, image1.size.height);
    [image1 drawInRect:imageRect];
    [image2 drawInRect:imageRect];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(void) setBackgroundOfView:(UIView*)view WithImageNamed:(NSString*)imageName{
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
//    NSLog(@"width:%f,height:%f",view.bounds.size.width,view.bounds.size.height);
}

-(void) setBackgroundOfView:(UIView*)view WithImage:(UIImage*)originImage{
    
    UIGraphicsBeginImageContext(view.frame.size);
    [originImage drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
    //    NSLog(@"width:%f,height:%f",view.bounds.size.width,view.bounds.size.height);
}

-(UIImage*) modifySkillButtonImage:(UIImage*)image WithPowerRate:(float)powerRate{
    
    if (powerRate <=0 || powerRate >1) {
        return nil;
    }
    
    CGSize size = image.size;
    float scale = image.scale;
    CGRect cropRect = CGRectMake(0, (1 - powerRate) * size.height * scale, size.width * scale, powerRate * size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage* cropedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsBeginImageContext(image.size);
    CGRect drawRect = CGRectMake(0, (1 - powerRate) * size.height, size.width, powerRate * size.height);
    [cropedImage drawInRect:drawRect];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    return resultImage;
    
}

@end
