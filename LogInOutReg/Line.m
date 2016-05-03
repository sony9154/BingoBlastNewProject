//
//  Line.m
//  HelloBingo
//
//  Created by WHITEer on 2016/03/27.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "Line.h"

@implementation Line

- (instancetype) initWith:(CGPoint)point1 And:(CGPoint)point2{
    
    self = [super init];

    self.startPoint = point1;
    self.endPoint = point2;
    
    return self;
    
}

@end
