//
//  Line.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/27.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Line : NSObject
//
//@property int x1;
//@property int y1;
//@property int x2;
//@property int y2;

//@property Point startPoint;
//@property Point endPoint;

@property CGPoint startPoint;
@property CGPoint endPoint;

- (instancetype) initWith:(CGPoint)point1 And:(CGPoint)point2;

@end
