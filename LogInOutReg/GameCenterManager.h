//
//  GameCenterManager.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/21.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "MultiPlayerGameViewcontroller.h"

@protocol GameCenterManagerDelegate
- (void) matchStarted;
- (void) matchEnded;
- (void) match:(GKMatch*)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer*)player;
@end

@interface GameCenterManager : NSObject<GKMatchmakerViewControllerDelegate,GKMatchDelegate,GKLocalPlayerListener>{
    
    BOOL userAuthenticated;
//    UIViewController* presentingViewController;
//    GKMatch* match;
    BOOL matchStarted;
//    id<GameCenterManagerDelegate>delegate;
    
}

@property (assign,readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController* presentingViewController;
@property (retain) GKMatch* match;
@property (assign) id<GameCenterManagerDelegate>delegate;
@property MultiPlayerGameViewcontroller* gameViewController;

+ (GameCenterManager*) shardManager;
- (void) authenticateLocalUserWith:(UIViewController*)presentingViewcontroller;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameCenterManagerDelegate>)theDelegate gameViewController:(MultiPlayerGameViewcontroller*)gameViewController;

@end
