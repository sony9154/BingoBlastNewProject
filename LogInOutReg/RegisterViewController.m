//
//  RegisterViewController.m
//  LogInOutReg
//
//  Created by Peter Yo on 4月/5/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNicknameTextField;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"註冊";
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.userEmailTextField.delegate = self;
    self.userPasswordTextField.delegate = self;
    self.repeatPasswordTextField.delegate = self;
    self.userNicknameTextField.delegate =self;
}

-(void)dimissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnPressed:(id)sender {
    
    NSString *userEmail = self.userEmailTextField.text;
    NSString *userPassword = self.userPasswordTextField.text;
    NSString *userRepeatPassword = self.repeatPasswordTextField.text;
    NSString *userNickname = self.userNicknameTextField.text;
    
    if(userEmail.length == 0 || userPassword.length == 0 || userRepeatPassword.length == 0 || userNickname.length == 0)
    {
        [self displayMyAlertTitle:@"注意!" alertMessage:@"所有欄位都要填寫"];
        return;
    }
    
    if ([self validateEmail:userEmail] != true) {
        [self displayMyAlertTitle:@"警告!" alertMessage:@"Email格式不正確!"];
        return;
    }
    
    if(userPassword != userRepeatPassword) {
        [self displayMyAlertTitle:@"請再次確認" alertMessage:@"密碼輸入不一致！"];
        return;
    }
    
    NSURL *myURL = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/userRegister.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
    request.HTTPMethod = @"POST";
    
    NSString *registerDataString = [NSString stringWithFormat:@"email=%@&password=%@&nickname=%@", userEmail, userPassword, userNickname];
    
    request.HTTPBody = [registerDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    //[NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable jsonData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error != nil) {
            NSLog(@"%@",error);
            return ;
        }
        
        //NSError *err = nil;
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Result: %@", result.description);
        
        
        NSString *resultValue = result[@"status"];
        BOOL isUserRegistered = false;
        if([resultValue  isEqual: @"Success"]) {
            isUserRegistered = true;
        }
        
        NSString *messageToDisplay = result[@"message"];
        if (!isUserRegistered) {
            messageToDisplay = result[@"message"];
            NSLog(@"MessageToDisplay is :%@",messageToDisplay);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self displayMyAlertTitle:messageToDisplay alertMessage:nil];
            
            /*UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:messageToDisplay preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [myAlert addAction:okAction];
            [self presentViewController:myAlert animated:true completion:nil];*/
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
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (userMessage) {
            
        } else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    [myAlert addAction:okAction];
    
    [self presentViewController:myAlert animated:true completion:nil];
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



















