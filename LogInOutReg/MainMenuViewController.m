//
//  MainMenuViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 4月/17/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicManager.h"
#import "SinglePlayerGameViewController.h"
#import "MultiPlayerGameViewcontroller.h"
#import "GameCenterManager.h"

@interface MainMenuViewController ()
{
    NSUserDefaults * userDefaults;
    AVAudioPlayer * audioPlayer;
}

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *useImageView;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[GameCenterManager shardManager] authenticateLocalUserWith:self];
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.userNameLabel.text = [userDefaults objectForKey:@"Name"];
    NSLog(@"userNameLabel is : %@",self.userNameLabel.text);
    NSString *fbPictureUrl = [userDefaults objectForKey:@"pictureUrl"];
    NSString *profilePicture = [userDefaults objectForKey:@"ProfilePicture"];


    if ([userDefaults boolForKey:@"isFBLoggedIn"] == true) {
        UIImage *fbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:fbPictureUrl]]];
        self.useImageView.layer.masksToBounds = true;
        self.useImageView.layer.cornerRadius = 22.0;
        self.useImageView.image = fbImage;
    }
    else if (![profilePicture isEqualToString:@""]) {
        UIImage *image = [UIImage imageWithData:[userDefaults objectForKey:@"image"]];
        self.useImageView.layer.masksToBounds = true;
        self.useImageView.layer.cornerRadius = 22.0;
        self.useImageView.image = image;
    }
    else {
        UIImage *image = [UIImage imageNamed:@"123456.jpg"];
        self.useImageView.layer.masksToBounds = true;
        self.useImageView.layer.cornerRadius = 22.0;
        self.useImageView.image = image;
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated
{
    UIImage *image = [UIImage imageWithData:[userDefaults objectForKey:@"image"]];
    self.useImageView.layer.masksToBounds = true;
    self.useImageView.layer.cornerRadius = 22.0;
    self.useImageView.image = image;
}

- (IBAction)settingsBtnPressed:(id)sender {

    [self playSound];

    SettingsViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];

    vc2.settingsNickname = self.userNameLabel.text;

    [self showViewController:vc2 sender:nil];
}

- (IBAction)settingsBtnPressed2:(id)sender {

    [self playSound];

    SettingsViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];

    vc2.settingsNickname = self.userNameLabel.text;

    [self showViewController:vc2 sender:nil];
}
- (IBAction)onlineGameButton:(id)sender {

    [[MusicManager shardManager].shardPlayer stop];
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    dispatch_async(dispatch_get_main_queue(), ^{
        MultiPlayerGameViewcontroller* mpgvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MultiPlayerGameViewcontroller"];
        [[GameCenterManager shardManager] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:mpgvc gameViewController:mpgvc];

    });

    [self playSound];

}
- (IBAction)howToPlayButton:(id)sender {

    [self playSound];
}
- (IBAction)LeaderBoardButton:(id)sender {

    [self playSound];
}
- (IBAction)singleGameButton:(id)sender {

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"AI強度" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* easy = [UIAlertAction actionWithTitle:@"簡單" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthEasy];
    }];
    UIAlertAction* normal = [UIAlertAction actionWithTitle:@"普通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthNormal];
    }];
    UIAlertAction* hard = [UIAlertAction actionWithTitle:@"困難" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthHard];
    }];
    UIAlertAction* dynamic = [UIAlertAction actionWithTitle:@"鏡中的你" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthDynamic];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:easy];
    [alertController addAction:normal];
    [alertController addAction:hard];
    [alertController addAction:dynamic];
    [alertController addAction:cancel];

    [self presentViewController:alertController animated:true completion:nil];




}
#pragma screen access

-(bool) shouldAutorotate{
    return false;
}

-(BOOL)prefersStatusBarHidden{
    return true;
}
- (void) startSinglePlayerGameWithAIStrength:(AIStrengthConfig)aiStr{

//    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    dispatch_async(dispatch_get_main_queue(), ^{
        SinglePlayerGameViewController* singlePlayerGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePlayerGameViewController"];
        singlePlayerGameViewController.aiStrength  = aiStr;
        [self presentViewController:singlePlayerGameViewController animated:true completion:nil];


    });

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) playSound {

    NSString * clickSound = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav"];
    NSURL * clickSoundURL = [NSURL fileURLWithPath:clickSound];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:clickSoundURL error:nil];
    audioPlayer.numberOfLoops = 1;
    [audioPlayer play];
}

@end
