//
//  SkillSelectButton.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/25.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "SkillButton.h"

@implementation SkillButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selected = false;
    }
    return self;
}


@end
