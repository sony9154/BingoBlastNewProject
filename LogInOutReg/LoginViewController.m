//
//  LoginViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 3月/31/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController ()<FBSDKLoginButtonDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登入";
    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    fbLoginButton.delegate = self;
    fbLoginButton.frame = CGRectMake((self.view.frame.size.width - fbLoginButton.frame.size.width)/2, self.view.frame.size.height * 0.8, fbLoginButton.frame.size.width, fbLoginButton.frame.size.height);
    [self.view addSubview:fbLoginButton];
    fbLoginButton.readPermissions = @[@"public_profile", @"email"];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    self.userEmailTextField.delegate =self;
    self.userPasswordTextField.delegate = self;
    
}

-(void)dimissKeyboard {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    NSDictionary *demandInfo = @{@"fields": @"name, email, first_name, last_name, picture.type(large)"};
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:demandInfo]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
         NSString *userEmail = (NSString*)result[@"email"];
         NSString *userNickname = (NSString*)result[@"name"];
         NSString *facebookID = (NSString*)result[@"id"];
         NSDictionary *picture = result[@"picture"];
         NSDictionary *data = picture[@"data"];
         NSString *fbProfilePictureURL = data[@"url"];
         [[NSUserDefaults standardUserDefaults]setObject:userNickname forKey:@"Name"];
         [[NSUserDefaults standardUserDefaults]setObject:userEmail forKey:@"Email"];
         [[NSUserDefaults standardUserDefaults]setObject:fbProfilePictureURL forKey:@"pictureUrl"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         NSURL *myURL = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/facebookLogin.php"];
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
         request.HTTPMethod = @"POST";
         NSString *registerDataString = [NSString stringWithFormat:@"email=%@&nickname=%@&fbID=%@", userEmail, userNickname,facebookID];
         request.HTTPBody = [registerDataString dataUsingEncoding:NSUTF8StringEncoding];
         NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
         //NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
         
         NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 MainMenuViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];

                 if (!error) {
                     mainMenuViewController.successNickname = (NSString*)result[@"name"];
                 }
                 //FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
                 [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isFBLoggedIn"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 if (accessToken) {
                     [self presentViewController:mainMenuViewController animated:YES completion:nil];
                 }
             });
         
         }];
         if (accessToken) {
            [task resume];
         };
    }];
    
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnPressed:(id)sender {
    
    NSString *userEmail = self.userEmailTextField.text;
    NSString *userPassword = self.userPasswordTextField.text;
    
    if(userEmail.length == 0 || userPassword.length == 0)
    {
        [self displayMyAlertTitle:@"請輸入帳號和密碼" alertMessage:nil];
        return;
    }
    if ([self validateEmail:userEmail] != true) {
        [self displayMyAlertTitle:@"警告!" alertMessage:@"Email格式不正確!"];
        return;
    }
    
    NSURL *myUrl = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/userLogin.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myUrl];
    request.HTTPMethod = @"POST";
    
    NSString *registerDataString = [NSString stringWithFormat:@"email=%@&password=%@", userEmail, userPassword];
    
    request.HTTPBody = [registerDataString dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable jsonData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"%@",error);
            return ;
        }
        
        //NSError *err = nil;
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"\nResult: %@", result.description);
        
        NSString *resultValue = result[@"status"];
        NSString *resultNickname = [result[@"details"] objectForKey:@"user_nickname"];
        NSString *resultID = [result[@"details"] objectForKey:@"id"];
        NSString *profilePicture = [result[@"details"] objectForKey:@"profile_picture"];
        //NSString *nicknameCut = [resultNickname substringFromIndex:5];
        
        if([resultValue isEqual:@"Success"]) {
            
            //NSString *userEmailStored = [[NSUserDefaults standardUserDefaults]stringForKey:userEmail];
            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isUserLoggedIn"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MainMenuViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
                    //mainMenuViewController.successName = self.userEmailTextField.text;
                    mainMenuViewController.successNickname = resultNickname;
                [[NSUserDefaults standardUserDefaults]setObject:resultNickname forKey:@"Name"];
                [[NSUserDefaults standardUserDefaults]setObject:userEmail forKey:@"Email"];
                [[NSUserDefaults standardUserDefaults]setObject:userPassword forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults]setObject:resultID forKey:@"ID"];
                [[NSUserDefaults standardUserDefaults]setObject:profilePicture forKey:@"ProfilePicture"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                [self showViewController:mainMenuViewController sender:nil];
                
            });
            
            NSLog(@"登入成功");

        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您的帳號或密碼錯誤" message:@"請重新輸入" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * restPassword = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.userPasswordTextField setText:@""];
                        [self.userPasswordTextField becomeFirstResponder];
                }];
                
                [alertController addAction:restPassword];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
             });
            
            NSLog(@"登入失敗");
        }
        
    }];
    
    [task resume];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void) displayMyAlertTitle:(NSString*)alertTitle alertMessage:(NSString*)userMessage {
    
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:alertTitle message:userMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [myAlert addAction:okAction];
    
    [self presentViewController:myAlert animated:true completion:nil];
}


- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
