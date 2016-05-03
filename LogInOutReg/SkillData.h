//
//  SkillData.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/29.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SKILL_MAX_POWER 3

@interface SkillData : NSObject

@property int skillID;
@property int power;

- (instancetype)initWithID:(int)skillID;

@end
