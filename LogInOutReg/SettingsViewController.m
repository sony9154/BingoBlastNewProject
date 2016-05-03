//
//  SettingsViewController.m
//  LogInOutReg
//
//  Created by 陳韋中 on 2016/4/26.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "SettingsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EntranceViewController.h"


@interface SettingsViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    NSUserDefaults * userDefaults;
    FBSDKAccessToken * accesssToken;
}
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;
@property (weak, nonatomic) IBOutlet UITextField *settingNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *settingEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *setttingPasswordTextField;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.settingNameTextField.text = [userDefaults objectForKey:@"Name"];
    self.settingEmailTextField.text = [userDefaults objectForKey:@"Email"];
    accesssToken = [FBSDKAccessToken currentAccessToken];
    if (accesssToken) {
        self.setttingPasswordTextField.text = @"";
    } else {
    self.setttingPasswordTextField.text = [userDefaults objectForKey:@"Password"];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
//    self.settingNameTextField.delegate =self;
}

-(void)dimissKeyboard {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editImageView:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新增照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍攝照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerwITHsourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"相簿" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerwITHsourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - UIImagePickerController Support

- (void) launchImagePickerwITHsourceType:(UIImagePickerControllerSourceType) sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] == false) {
        NSLog(@"SourceType");
        return;
    }
    
    // Prepare UIImagePickerController
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = sourceType;
    imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:true completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    NSString *type = info[UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString*)kUTTypeImage]) {
        // Image
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        
        UIImage *resizedImage = [self resizeFromImage:originalImage];
        
        NSData *jpegData = UIImageJPEGRepresentation(resizedImage, 0.6);
        NSLog(@"PhototSize: %fx%f (%ld bytes)",originalImage.size.width,originalImage.size.height,jpegData.length);
        
        _settingImageView.image = resizedImage;
        
        // Save in Photo Library
        [self saveToPhotoLibrary:resizedImage];
        
    } else {
        
        
    }
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)saveToPhotoLibrary:(UIImage*) image {
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (error) {
            NSLog(@"Save to PhotoLibrary Fail: %@",error.description);
        } else {
            NSLog(@"Image saved OK!");
        }
        
    }];
    
}

- (UIImage*) resizeFromImage:(UIImage*) sourceImage {
    
    // Check sourceImage's size
    CGFloat maxValue = 1024.0;
    CGSize originalSize = sourceImage.size;
    if (originalSize.width <= maxValue && originalSize.height <= maxValue) {
        return sourceImage;
    }
    
    // Decide final size
    CGSize targetSize;
    if (originalSize.width >= originalSize.height) {
        
        CGFloat ratio = originalSize.width/maxValue;
        targetSize = CGSizeMake(maxValue, originalSize.height/ratio);
    } else {
        // height > wight
        CGFloat ratio = originalSize.height/maxValue;
        targetSize = CGSizeMake(originalSize.height/ratio, maxValue);
    }
    
    // 建立虛擬畫布
    UIGraphicsBeginImageContext(targetSize);
    // 圖片畫到虛擬畫面上
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 結束
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logOutButton:(id)sender {
    
    //FB logout
    [[FBSDKLoginManager new] logOut];
    
    //Account logout
    [userDefaults setBool:false forKey:@"isUserLoggedIn"];
    [userDefaults synchronize];
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    EntranceViewController * mmvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"EntranceViewController"];
    [self presentViewController:mmvc animated:true completion:nil];
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
