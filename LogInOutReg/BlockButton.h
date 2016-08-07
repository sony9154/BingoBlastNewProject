//
//  BlockButton.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/06.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockButton : UIButton

@property int x;
@property int y;

- (instancetype)initWithFrame:(CGRect)frame X:(int)x Y:(int)y;

@end
