//
//  HolleToPlayViewController.m
//  LogInOutReg
//
//  Created by 陳韋中 on 2016/4/26.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

#import "HolleToPlayViewController.h"

@interface HolleToPlayViewController ()
{
    NSString * introducing;
    NSString * specialSkills;
}
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation HolleToPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    introducing = @"怎麼玩？ \n盤面會隨機從1~75中挑出25個數字組合而成 \n電腦挑選隨機號碼並從畫面上方顯示，一開始的數字會出現在左邊並且在出現新的數字時會往右邊移動\n如果數字離開畫面外代表此數字已經無法再選擇。\n如盤面中的號碼與其相同\n即可點擊並獲得分數。\n但是錯誤的點擊則會扣除您的分數。\n當連成線時會有Bonus加分。\n當數字被電腦喊完的同時結束遊戲。\n結束遊戲時會比較雙方分數，分數較高者獲勝。";
    specialSkills = @"每個數字底下會有不同的顏色 \n當有相同的顏色消除次數達到三次 \n即可點擊上面顏色球 \n向右滑動您的技能發動條 \n即可產生干擾技能影響對手消除進度。";
    
    
    
    


}
- (IBAction)introducingButton:(id)sender {
    
    _inputTextView.text = introducing;
    _inputTextView.textAlignment = 0;
    _inputTextView.font = [UIFont systemFontOfSize:15];
    
}
- (IBAction)specailSkillButton:(id)sender {
    _inputTextView.text = specialSkills;
    _inputTextView.textAlignment = 0;
    _inputTextView.font = [UIFont systemFontOfSize:15];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backGameHome:(id)sender {
    
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
