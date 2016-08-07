//
//  SkillData.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/29.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "SkillData.h"

@implementation SkillData

- (instancetype)initWithID:(int)skillID
{
    self = [super init];
    if (self) {
        self.skillID = skillID;
        self.power = 0;
    }
    return self;
}

@end
