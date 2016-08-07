//
//  SinglePlayerGameViewController.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/12.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "GameViewController.h"
#import "AI.h"

//#define AI_ACTION_INTERVAL CALL_NUMBER_TIME_INTERVAL + 3.5 //unit is second

#define AI_ACTION_INTERVAL_EASY CALL_NUMBER_TIME_INTERVAL + 6 //unit is second
#define AI_ACTION_INTERVAL_NORMAL CALL_NUMBER_TIME_INTERVAL + 5 //unit is second
#define AI_ACTION_INTERVAL_HARD CALL_NUMBER_TIME_INTERVAL + 4 //unit is second
@interface SinglePlayerGameViewController : GameViewController
{
    AI* ai;
    UIView* aiBoardView;
    NSTimer* aiTimer;
//    __weak IBOutlet UILabel *aiScoreLabel;
    UIImageView* drawAIBoardView;//used to draw line...
}

@property AIStrengthConfig aiStrength; // 0 -> easy 1 -> normal 2 -> hard
//- (instancetype) initWithAIStrength:(int)AIStr;

@end