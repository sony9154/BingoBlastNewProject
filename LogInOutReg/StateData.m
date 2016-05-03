//
//  StateData.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/29.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "StateData.h"

@implementation StateData

- (instancetype)initWithID:(int)stateID
{
    self = [super init];
    if (self) {
        self.isRemain = false;
        self.remainTime = 0;
        self.stateID = stateID;
    }
    return self;
}

@end
