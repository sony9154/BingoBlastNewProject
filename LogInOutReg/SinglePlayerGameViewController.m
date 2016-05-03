//
//  SinglePlayerGameViewController.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/12.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "SinglePlayerGameViewController.h"

@interface SinglePlayerGameViewController ()
@end

@implementation SinglePlayerGameViewController
{
    double AIActionInterval;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createAIBoard];
    [self createAI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.}
}

#pragma mark - AI access

- (void) createAI{
    
    
    ai = [[AI alloc] initWithPlayer:opponent Strength:self.aiStrength];
    
    AIActionInterval = 0.0;
    
    switch (self.aiStrength) {
        case AIStrengthEasy:
            AIActionInterval = AI_ACTION_INTERVAL_EASY;
            break;
        case AIStrengthNormal:
            AIActionInterval = AI_ACTION_INTERVAL_NORMAL;
            break;
        case AIStrengthHard:
            AIActionInterval = AI_ACTION_INTERVAL_HARD;
            break;
        case AIStrengthDynamic:
            AIActionInterval = AI_ACTION_INTERVAL_EASY;
            break;
        default:
            break;
    }
    
    aiTimer = [NSTimer scheduledTimerWithTimeInterval:AIActionInterval target:self selector:@selector(aiAction) userInfo:nil repeats:true];
    
}

- (void) aiAction{
    
//    NSLog(@"AI Action");
    [ai pressBlock:callNumbers];
    [self aiUseSkill];
    [self updateGame];
    
    
    if(self.aiStrength == AIStrengthDynamic){
        if(opponent.score <= player.score){
            [aiTimer invalidate];
//            AIActionInterval = AIActionInterval >= 2.5 ? AIActionInterval - 2 : 0.5;
//            ai.missingRate = ai.missingRate >= 5 ?  ai.missingRate - 5 : 0;
            AIActionInterval = AIActionInterval * 0.5 >= 0.5 ? AIActionInterval * 0.5 : 0.5;
            ai.missingRate = ai.missingRate * 0.5 > 5 ?  ai.missingRate * 0.5 : 0;
            aiTimer = [NSTimer scheduledTimerWithTimeInterval:AIActionInterval target:self selector:@selector(aiAction) userInfo:nil repeats:true];
        }else if(opponent.score >= player.score){
            [aiTimer invalidate];
//            if(AIActionInterval <= 8)AIActionInterval += 2;
//            if(ai.missingRate <= 30)ai.missingRate +=5;
            AIActionInterval = AIActionInterval * 2 <= 10 ? AIActionInterval * 2 : 10;
            ai.missingRate = (ai.missingRate * 2) + 5 < 30  ?  (ai.missingRate * 2) + 5 : 30;
            aiTimer = [NSTimer scheduledTimerWithTimeInterval:AIActionInterval target:self selector:@selector(aiAction) userInfo:nil repeats:true];
            
        }
    }
    //NSLog(@"AIActionInterval: %f ai's missingRate: %d",AIActionInterval,ai.missingRate);
}

- (void) aiUseSkill{
    
    int selectedSkillIndex = -1;
    
    //get index of selected skill
    for (int n = 0; n < SKILL_COUNT; n++) {
        if(opponent.skillDatas[n].power >= 3){
            selectedSkillIndex = n;
            break;
        }
    }
    //index out of array of skills
    if(selectedSkillIndex < 0 || selectedSkillIndex >= SKILL_COUNT)return;
    
    //use skill and set power of skill to 0
    Skill* skill = skills[selectedSkillIndex];
    SkillData* skillData = opponent.skillDatas[selectedSkillIndex];
    
    //Opponent of AI is player.
    if(skill.isTargetOpponent){
        [skill effectTo:player];
    }else{
        [skill effectTo:opponent];
    }
    skillData.power = 0;
    [self updateGame];
    
}

//- (void)accessState{
//    [super accessState];
//    
//    for (int n = 0; n < STATE_COUNT; n++) {
//        
//        StateData* stateData = opponent.stateDatas[n];
//        State* state = states[n];
//        if(stateData.isRemain){
//            
//            stateData.remainTime -= STATE_ACCESS_INTERVAL;
//            if(stateData.remainTime <= 0){
//                stateData.isRemain = false;
//                [state remove:opponent];
//                [self updateGame];
//            }
//            
//        }
//        
//    }
//    
//}

@end
