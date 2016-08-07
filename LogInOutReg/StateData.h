//
//  StateData.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/29.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateData : NSObject

@property BOOL isRemain;
@property int remainTime;
@property int stateID;

- (instancetype)initWithID:(int)stateID;

@end
