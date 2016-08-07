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
    NSDictionary *dict;
    NSString *nameid;
    NSString *name;
    NSString *picture;
    NSString * leaderboardwins;
    NSString * playName;
    NSUserDefaults * userDefaults;
}


@property (weak, nonatomic) IBOutlet UITableView *leaderboardTableView;
@property (nonatomic,strong) NSMutableArray *leaderboardNameArray;
@property (nonatomic,strong) NSMutableArray *leaderboardNumberArray;
@property (weak, nonatomic) IBOutlet UILabel *myNumber;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userDefaults = [NSUserDefaults standardUserDefaults];
    playName = [userDefaults objectForKey:@"Name"];
    
    
    
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
    [self.leaderboardTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadNewsList {
    
    nameid = @"fbID";
    name = @"user_nickname";
    picture = @"profile_picture";
    leaderboardwins = @"victory_no";
    adata = [[NSMutableArray alloc] init];
    
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
        
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@" %@",jsonObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSDictionary *dataDict in jsonObject) {
                NSString *strFbID = [dataDict objectForKey:@"fbID"];
                NSString *strProfile = [dataDict objectForKey:@"profile_picture"];
                NSString *strName = [dataDict objectForKey:@"user_nickname"];
                NSString * strWins = [dataDict objectForKey:@"victory_no"];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:strFbID,nameid,strProfile,picture,strName,name,strWins,leaderboardwins,nil];
                [adata addObject:dict];
            }
            
            [self.leaderboardTableView reloadData];
            
            for (int i = 0; i < adata.count ; i++) {
                NSDictionary * info = [adata objectAtIndex:i];
                NSString * name1 = @"user_nickname";
                //NSString * victory = @"victory_no";
                NSString * name2 = [info objectForKey:name1];
                //NSString * victory1 = [info objectForKey:victory];
                
                if ([name2 isEqualToString:playName]) {
                    self.myNumber.text = [info objectForKey:@"victory_no"];
                    self.myNumber.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:25];
                }
            }
        });
        
    }];
    
    [task resume];}

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
    cell.leaderboardNumber.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    
    NSDictionary *info = [adata objectAtIndex:indexPath.row];
    cell.leaderboardName.text = [info objectForKey:name];
    cell.leaderboardName.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
    cell.wins.text = [info objectForKey:leaderboardwins];
    
    
    
    NSString * fb = @"fbID";
    NSString * fbval = [info objectForKey:fb];
    
    //    if(fbval != 0){
    //        NSLog(@"fbID %@",fbval);
    //    }else{
    //        NSLog(@"fbID = 0");
    //    }
    
    NSString * tmp = @"profile_picture";
    NSString * tmpval = [info objectForKey:tmp];
    
    //    if(tmpval!= nil){
    //        NSLog(@"picture %@",tmpval);
    //    }else{
    //        NSLog(@"picture = nil");
    //    }
    
    if ((![tmpval  isEqualToString: @""])) {
        NSString *idString = [info objectForKey:picture];
        NSLog(@"%@",idString);
        NSURL *baseURL = [NSURL URLWithString:@"http://1.34.9.137/HelloBingo/uploads/"];
        NSURL *url = [baseURL URLByAppendingPathComponent:idString];
//        NSLog(@"%@",url);
        NSData *data =[NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        cell.leaderboardImageView.image = image;
        cell.leaderboardImageView.layer.masksToBounds = true;
        cell.leaderboardImageView.layer.cornerRadius = 22.0;
    } else if ((![fbval  isEqualToString: @"0"])){
        NSString *fbIDString = [info objectForKey:nameid];
        NSLog(@"%@",fbIDString);
        NSString *profilePicURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", fbIDString];
        NSLog(@"%@",profilePicURL);
        NSURL *urlfbID = [NSURL URLWithString:profilePicURL];
        NSData *datab =[NSData dataWithContentsOfURL:urlfbID];
        UIImage *image = [UIImage imageWithData:datab];
        cell.leaderboardImageView.layer.masksToBounds = true;
        cell.leaderboardImageView.layer.cornerRadius = 22.0;
        cell.leaderboardImageView.image = image;
    } else {
        UIImage *image = [UIImage imageNamed:@"123456.jpg"];
        cell.leaderboardImageView.layer.masksToBounds = true;
        cell.leaderboardImageView.layer.cornerRadius = 22.0;
        cell.leaderboardImageView.image = image;
    }
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
