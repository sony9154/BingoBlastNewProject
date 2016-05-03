//
//  LeaderboardViewController.m
//  BingoBlast
//
//  Created by 陳韋中 on 2016/4/10.
//  Copyright © 2016年 hdes93404lg. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardTableViewCell.h"

@interface LeaderboardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *adata;
}

@property (weak, nonatomic) IBOutlet UITableView *leaderboardTableView;
@property (nonatomic,strong) NSMutableArray *leaderboardNameArray;
@property (nonatomic,strong) NSMutableArray *leaderboardNumberArray;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"排行榜";
    
    self.leaderboardTableView.delegate = self;
    self.leaderboardTableView.dataSource = self;
    
    //self.leaderboardNameArray = [[NSMutableArray alloc] initWithObjects:@"阿中",@"Peter",@"政威",@"彥程",@"家豪",@"阿中",@"Peter",@"政威",@"彥程",@"家豪",nil];
    
    self.leaderboardNumberArray = [[NSMutableArray alloc] init];
    for (int i=1; i < 100; i++) {
        NSString *number = [NSString stringWithFormat:@"%i",i];
        [self.leaderboardNumberArray addObject:number];
    }
    [self downloadNewsList];

}
    

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadNewsList {
    
    // Perform a real download.
    NSURL *url = [NSURL URLWithString:@"http://1.34.9.137:80/HelloBingo/takeFriendList.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 使用 NSURLSeesion
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 檢查是否有任何錯誤
        if (error) {
            NSLog(@"Error: %@",error.description);
            return;
        }
        
        // 處理下載來的 date，解碼並轉成字串
//        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"content: %@",content);
        
        adata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.leaderboardTableView reloadData];
            
        });
        
    }];
    
    // 開始工作下載
    [task resume];
}

#pragma mark - TableView!

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [adata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *Number = self.leaderboardNumberArray[indexPath.row];
    cell.leaderboardNumber.text = [Number description];
    
    //NSString *friend = self.leaderboardNameArray[indexPath.row];
    //cell.leaderboardName.text = [friend description];
    
    UIImage *image = [UIImage imageNamed:@"123456.jpg"];
    cell.leaderboardImageView.layer.masksToBounds = true;
    cell.leaderboardImageView.layer.cornerRadius = 22.0;
    cell.leaderboardImageView.image = image;
    
    NSDictionary *info = [adata objectAtIndex:indexPath.row];
    cell.leaderboardName.text = [info description];
    
    
    return cell;
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
