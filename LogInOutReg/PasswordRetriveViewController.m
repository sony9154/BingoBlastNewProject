//
//  PasswordRetriveViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 5月/5/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "PasswordRetriveViewController.h"

@interface PasswordRetriveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation PasswordRetriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendEmailBtnPressed:(id)sender {
    
    NSString *userEmail = self.emailTextField.text;
    
    if(userEmail.length == 0)
    {
        [self displayMyAlertTitle:@"注意!" alertMessage:@"請填寫註冊的email"];
        return;
    }
    
    if ([self validateEmail:userEmail] != true) {
        [self displayMyAlertTitle:@"警告!" alertMessage:@"Email格式不正確!"];
        return;
    }
    
    
    NSURL *myUrl = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/passwordRetrive.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myUrl];
    request.HTTPMethod = @"POST";
    
    NSString *registerDataString = [NSString stringWithFormat:@"email=%@", userEmail];
    
    request.HTTPBody = [registerDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable jsonData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([result[@"status"] isEqual:@"Success"]){
                [self displayMyAlertTitle:@"請到註冊信箱收取密碼" alertMessage:nil];
            } else {
                [self displayMyAlertTitle:@"此註冊帳號不存在" alertMessage:nil];
            }
            
        });
        
        
        
        
        
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
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [myAlert addAction:okAction];
    [self presentViewController:myAlert animated:true completion:nil];
    
}
- (IBAction)backgroundTap:(id)sender {
    [self.emailTextField resignFirstResponder];
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end















