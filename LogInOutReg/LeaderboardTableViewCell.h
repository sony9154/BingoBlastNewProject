//
//  LeaderboardTableViewCell.h
//  BingoBlast
//
//  Created by 陳韋中 on 2016/4/10.
//  Copyright © 2016年 hdes93404lg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leaderboardImageView;
@property (weak, nonatomic) IBOutlet UILabel *leaderboardName;
@property (weak, nonatomic) IBOutlet UILabel *leaderboardNumber;

@end
