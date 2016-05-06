//
//  MusicManager.h
//  LogInOutReg
//
//  Created by 李政威 on 2016/5/5.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicManager : NSObject

@property AVAudioPlayer* shardPlayer;

+(instancetype)shardManager;

@end
