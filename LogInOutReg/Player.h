//
//  Player.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "SkillData.h"
#import "StateData.h"

#define SKILL_COUNT 3
#define STATE_COUNT 3

@interface Player : NSObject

@property NSString* name;
@property NSString* photoPath;
@property Board* board;
@property int score;
@property int penalty;
@property BOOL isSurrender;
//@property BOOL isSeal;
//@property BOOL isAid;
//@property NSMutableArray* skills;
@property NSMutableArray<SkillData*>* skillDatas;
@property NSMutableArray<StateData*>* stateDatas;

- (instancetype) initWithName:(NSString*)name Photo:(NSString*)photoPath;
- (int) caculateScore;

@end
