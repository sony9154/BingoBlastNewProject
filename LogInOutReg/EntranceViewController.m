//
//  ViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 3月/31/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "EntranceViewController.h"
#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicManager.h"

@interface EntranceViewController ()
{
    NSUserDefaults * userDefaults;
//    AVAudioPlayer * audioPlayer;
    FBSDKAccessToken* accessToken;
}

@end

@implementation EntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults  = [NSUserDefaults standardUserDefaults];
    //Music
    NSString * musicFilePath = [[NSBundle mainBundle] pathForResource:@"backgroundMusic" ofType:@"mp3"];
    NSURL * soundFileURL = [NSURL fileURLWithPath:musicFilePath];
    
    
    
    [MusicManager shardManager].shardPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    
    AVAudioPlayer* audioPlayer = [MusicManager shardManager].shardPlayer;
    
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
    
    
}
- (IBAction)startButton:(id)sender {
    
    NSString * clickSound = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav"];
    NSURL * clickSoundURL = [NSURL fileURLWithPath:clickSound];
    
    AVAudioPlayer* audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:clickSoundURL error:nil];
    audioPlayer.numberOfLoops = 1;
    [audioPlayer play];
    
    
    
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    accessToken = [FBSDKAccessToken currentAccessToken];
    if(accessToken){
        MainMenuViewController* mmvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
        [self presentViewController:mmvc animated:true completion:nil];
    }
    if ([userDefaults boolForKey:@"isUserLoggedIn"] == true) {
        MainMenuViewController* mmvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
        [self presentViewController:mmvc animated:true completion:nil];
    }
    LoginViewController* lvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:lvc animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
