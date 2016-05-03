//
//  Board.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/27.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Line.h"
#import "CallNumbers.h"
#define LINE_LENGTH 5

@interface Board : NSObject
{
    Block* blocks[LINE_LENGTH][LINE_LENGTH];
}
//@property Block* blocks;
@property NSMutableArray* lines;

//@property const int LINE_LENGTH;

- (void) createBlocks;
- (Block*) getBlockX:(int)x Y:(int)y;
- (NSMutableArray*) checkLines;
@end
