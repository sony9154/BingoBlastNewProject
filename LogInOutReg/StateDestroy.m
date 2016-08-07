//
//  StateDestroy.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/28.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "StateDestroy.h"

@implementation StateDestroy

- (void)remove:(Player*)target{
    
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
            
            [target.board getBlockX:x Y:y].isDestroyed = false;
            
        }
    }
    
}

@end
