//
//  BlockButton.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/06.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame X:(int)x Y:(int)y
{
    self = [super initWithFrame:frame];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

@end
