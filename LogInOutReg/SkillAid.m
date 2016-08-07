//
//  SkillDestroy.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/24.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "SkillAid.h"


@implementation SkillAid

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Aid";
        self.skillID = SkillIDAid;
        self.isTargetOpponent = false;
//        self.power = 0;
    }
    return self;
}

-(void)effectTo:(Player*)target{
    
    target.stateDatas[self.skillID].isRemain = true;
    target.stateDatas[self.skillID].remainTime = STATE_AID_DURATION;
    
}

@end
