//
//  AI.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/19.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallNumbers.h"
#import "Board.h"
#import "Player.h"

//#define MISSING_RATE 5 //unit is %,0~100

#define MISSING_RATE_EASY 15
#define MISSING_RATE_NORMAL 5
#define MISSING_RATE_HARD 0

typedef enum{
    AIStrengthEasy = 0,
    AIStrengthNormal,
    AIStrengthHard,
    AIStrengthDynamic
}AIStrengthConfig;


@interface AI : NSObject 
{
    AIStrengthConfig aiStrength;
    Player* aiPlayer;
}
//@property AIStrengthConfig aiStrength; // 0 -> easy 1 -> normal 2 -> hard

@property int missingRate;

- (instancetype) initWithPlayer:(Player*)player Strength:(AIStrengthConfig)strength;
- (Block*)pressBlock:(CallNumbers*)callNumbers;

@end