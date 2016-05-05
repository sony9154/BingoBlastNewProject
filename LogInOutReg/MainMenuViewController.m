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
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.userNameLabel.text = [userDefaults objectForKey:@"Name"];
    
    NSLog(@"userNameLabel is : %@",self.userNameLabel.text);
    
    UIImage * image = [UIImage imageWithData:[userDefaults objectForKey:@"image"]];
    self.useImageView.layer.masksToBounds = true;
    self.useImageView.layer.cornerRadius = 22.0;
    self.useImageView.image = image;
}

- (void) viewWillAppear:(BOOL)animated {
    UIImage * image = [UIImage imageWithData:[userDefaults objectForKey:@"image"]];
    self.useImageView.layer.masksToBounds = true;
    self.useImageView.layer.cornerRadius = 22.0;
    self.useImageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self playSound];
}
- (IBAction)howToPlayButton:(id)sender {
    
    [self playSound];
}
- (IBAction)LeaderBoardButton:(id)sender {
    
    [self playSound];
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
