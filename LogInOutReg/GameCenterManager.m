//
//  GameCenterManager.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/21.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "GameCenterManager.h"

@implementation GameCenterManager

#pragma mark Initialization

static GameCenterManager* shardManager;

+ (GameCenterManager*) shardManager{
    if(!shardManager)shardManager = [[GameCenterManager alloc] init];
    return shardManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gameCenterAvailable = [self isGameCenterAvailable];
        if(self.gameCenterAvailable){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}

- (BOOL) isGameCenterAvailable{
    
    // check GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if ios version is 4.1 or later
    NSString* requestVersion = @"4.1";
    NSString* currentVersion = [[UIDevice currentDevice] systemVersion];
    BOOL isVersionSupport = ([currentVersion compare:requestVersion options:NSNumericSearch]!= NSOrderedAscending);
    return gcClass && isVersionSupport;
    
}

-(void) authenticationChanged{
    
    if([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated){
        userAuthenticated = true;
    }else if(![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated){
        userAuthenticated = false;
    }

}

#pragma mark user method

- (void) authenticateLocalUserWith:(UIViewController*)presentingViewcontroller{
    
    if(!_gameCenterAvailable)return;
    if([GKLocalPlayer localPlayer].authenticated == false)[[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController * vc, NSError * error) {
        
        if(error){
            
        }else if(vc){
            [presentingViewcontroller presentViewController:vc animated:true completion:nil];
            userAuthenticated = true;
        }
        
    }];
    
}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameCenterManagerDelegate>)theDelegate gameViewController:(MultiPlayerGameViewcontroller*)gameViewController{
    
    if(!_gameCenterAvailable)return;
    
    matchStarted = false;
    self.match = nil;
    _presentingViewController = viewController;
    _delegate = theDelegate;
    _gameViewController = gameViewController;
    [_presentingViewController dismissViewControllerAnimated:true completion:nil];
    
    GKMatchRequest* request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController* mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [_presentingViewController presentViewController:mmvc animated:true completion:nil];
    
}

#pragma mark - GKMatchMakerViewControllerDelegate

- (void) matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController{
    [_presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error{
    [_presentingViewController dismissViewControllerAnimated:true completion:nil];
}

-(void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch{
    [_presentingViewController dismissViewControllerAnimated:true completion:nil];
    _match = theMatch;
    _match.delegate = self;
    if(!matchStarted &&_match.expectedPlayerCount == 0){
        
        [_presentingViewController presentViewController:_delegate animated:true completion:nil];
        
    }
}

#pragma mark - GKMatchDelegate

- (void) match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player{
    if(_match != theMatch)return;
    [_delegate match:theMatch didReceiveData:data fromRemotePlayer:player];
    
}

-(void)match:(GKMatch *)theMatch player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state{
    
    if(_match != theMatch)return;
    
    switch (state) {
        case GKPlayerStateConnected:
            NSLog(@"player connected");
            if(!matchStarted && theMatch.expectedPlayerCount == 0){
                NSLog(@"ready to start match");
                matchStarted = true;
                [_delegate matchStarted];
            }
            break;
        case GKPlayerStateDisconnected:
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [_delegate matchEnded];
            break;
            
        default:
            break;
    }
    
}

-(void)match:(GKMatch *)match didFailWithError:(NSError *)error{
    
    NSLog(@"match failed with error %@", error.localizedDescription);
    [_delegate matchEnded];
    
}

#pragma mark - Invite events
- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite {
    
    [[GKMatchmaker sharedMatchmaker] matchForInvite:invite completionHandler:^(GKMatch * _Nullable match, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"Error:%@",[error description]);
        }else{
            
            [_presentingViewController presentViewController:_delegate animated:true completion:nil];
        }
        
    }];
    
}
@end
