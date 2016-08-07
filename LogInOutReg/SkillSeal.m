//
//  SkillDestroy.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/24.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "SkillSeal.h"


@implementation SkillSeal

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Seal";
        self.skillID = SkillIDSeal;
        self.isTargetOpponent = true;
//        self.power = 0;
    }
    return self;
}

-(void)effectTo:(Player*)target{
    
    int hitPlace = (int)(arc4random()%(LINE_LENGTH*LINE_LENGTH));
    int hitPlace_x = hitPlace % LINE_LENGTH;
    int hitPlace_y = hitPlace / LINE_LENGTH;
    int range = 3;
    
    target.stateDatas[self.skillID].isRemain = true;
    target.stateDatas[self.skillID].remainTime = STATE_SEAL_DURATION;
    //find blocks in effect range and uncheck them.
    for (int y = 0; y<LINE_LENGTH; y++) {
        for(int x = 0;x<LINE_LENGTH;x++){
            if (abs(x-hitPlace_x) + abs(y-hitPlace_y) < range) {
                Block* block = [target.board getBlockX:x Y:y];
                block.isSealed = true;
            }
            
        }
    }
    
    
}

@end
