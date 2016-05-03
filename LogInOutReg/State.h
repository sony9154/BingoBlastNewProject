//
//  State.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/28.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface State : NSObject

//@property PlayerBase* target;

- (void)remove:(Player*)target;

@end
