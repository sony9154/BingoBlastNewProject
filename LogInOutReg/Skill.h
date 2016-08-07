//
//  Skill.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/24.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "CallNumbers.h"
#import "Player.h"

typedef enum SkillID{
    SkillIDDestroy,
    SkillIDSeal,
    SkillIDAid
}SkillID;

@interface Skill : NSObject

@property SkillID skillID;
@property NSString* name;
@property BOOL isTargetOpponent;
//@property int power;

-(void)effectTo:(Player*)target;

@end
