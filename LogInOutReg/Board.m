//
//  Board.m
//  HelloBingo
//
//  Created by WHITEer on 2016/03/27.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "Board.h"
//
//@interface Board ()
//@end

@implementation Board

- (instancetype)init
{
    self = [super init];
    if (self) {
//        LINE_LENGTH = LINE_LENGTH_DEFINE;
        [self createBlocks];
//        self.lines = [[NSMutableArray alloc] init];
        
        
        
    }
    return self;
}

- (void) createBlocks{
    
    //create array blocks 創造格子的陣列
    
    for(int x = 0; x < LINE_LENGTH; x++){
        for(int y = 0; y < LINE_LENGTH;y++){
            
            blocks[x][y] = [[Block alloc] init];
//            NSLog(@"%i",blocks[n][m].number);
        }
    }
    
    //make random number 產生隨機數字
    NSMutableArray* oneToHundred = [[NSMutableArray alloc] init];
    for (int n = 1; n <= ALL_NUMBER_COUNT; n++) {
        [oneToHundred addObject:[NSNumber numberWithInt:n]];
    }
    
    for(int x = 0; x < LINE_LENGTH; x++){
        for (int y = 0; y < LINE_LENGTH; y++) {
            
            int tmpIndex = arc4random() % oneToHundred.count;
            blocks[x][y].number = [[oneToHundred objectAtIndex:tmpIndex] intValue];
            [oneToHundred removeObjectAtIndex:tmpIndex];
            
        }
    }
    
//    //印出數字
//    for(int n = 0; n < LINE_LENGTH; n++){
//        for(int m = 0; m < LINE_LENGTH;m++){
//            
//                        NSLog(@"%i",blocks[n][m].number);
//        }
//    }
    
    
//    self.blocks = [[NSMutableArray alloc] init];
//    for(int n = 0; n < LINE_LENGTH; n++){
//        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
//        for (int m = 0; m < LINE_LENGTH; m++) {
//            [tempArray addObject:[[Block alloc] init]];
//        }
//        [self.blocks addObject:tempArray];
//    }
//    for(int n = 0; n < LINE_LENGTH; n++){
//        for(int m = 0; m < LINE_LENGTH; m++){
//            NSLog(@"%d",((Block*)[[self.blocks objectAtIndex:n] objectAtIndex:m]).number);
//        }
//    }
    
    
    
    
}

- (Block*) getBlockX:(int)x Y:(int)y{
    return blocks[x][y];
}

- (NSMutableArray*) checkLines{
    
    int count = 0;
    self.lines = [[NSMutableArray alloc] init];
    
    // check rows
    for (int y = 0; y < LINE_LENGTH; y++) {
        count = 0;
        for(int x = 0; x <LINE_LENGTH; x++){
            if(blocks[x][y].isChecked)count++;
        }
        if(count == LINE_LENGTH){
            CGPoint point1 = {0,y};
            CGPoint point2 = {LINE_LENGTH - 1,y};
            [self.lines addObject:[[Line alloc ]initWith:point1 And:point2]];
        }
    }
    
    // check columns
    for(int x = 0; x < LINE_LENGTH; x++){
        count = 0;
        for(int y = 0; y < LINE_LENGTH; y++){
            if(blocks[x][y].isChecked)count++;
        }
        if(count ==LINE_LENGTH){
            CGPoint point1 = {x,0};
            CGPoint point2 = {x,LINE_LENGTH - 1};
            [self.lines addObject:[[Line alloc ]initWith:point1 And:point2]];
        }
    }
    
    // check slashs
    count = 0;
    for(int n = 0; n <LINE_LENGTH; n++){
        if(blocks[n][n].isChecked)count++;
    }
    if(count == LINE_LENGTH){
        CGPoint point1 = {0,0};
        CGPoint point2 = {LINE_LENGTH - 1,LINE_LENGTH - 1};
        [self.lines addObject:[[Line alloc ]initWith:point1 And:point2]];
    }

    count = 0;
    for(int n = 0; n <LINE_LENGTH; n++){
        if(blocks[n][LINE_LENGTH - 1 - n].isChecked)count++;
        
    }
    if(count == LINE_LENGTH){
        CGPoint point1 = {0,LINE_LENGTH - 1};
        CGPoint point2 = {LINE_LENGTH - 1,0};
        [self.lines addObject:[[Line alloc ]initWith:point1 And:point2]];
    }
    
    return self.lines;
}

@end






