//
//  MusicManager.m
//  LogInOutReg
//
//  Created by 李政威 on 2016/5/5.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "MusicManager.h"

@implementation MusicManager

static MusicManager* shardManager;

+(instancetype)shardManager{
    if (!shardManager) {
        shardManager = [[MusicManager alloc]init];
    }
    return shardManager;
}

@end
