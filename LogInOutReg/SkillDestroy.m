//
//  SkillDestroy.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/24.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "SkillDestroy.h"

@implementation SkillDestroy

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Destroy";
        self.skillID = SkillIDDestroy;
        self.isTargetOpponent = true;
//        self.power = 0;
    }
    return self;
}

//-(void)effectTo:(Player*)target{
//    
//    int hitPlace = (int)(arc4random()%(LINE_LENGTH*LINE_LENGTH));
//    int hitPlace_x = hitPlace % LINE_LENGTH;
//    int hitPlace_y = hitPlace / LINE_LENGTH;
//    int range = 2;
//    
//    //find blocks in effect range and uncheck them.
//    for (int y = 0; y<LINE_LENGTH; y++) {
//        for(int x = 0;x<LINE_LENGTH;x++){
//            if (abs(x-hitPlace_x) + abs(y-hitPlace_y) < range) {
//                Block* block = [target.board getBlockX:x Y:y];
//                block.isChecked = false;
//                
//            }
//            
//        }
//    }
//    
//}

-(void)effectTo:(Player*)target{
    
    target.stateDatas[self.skillID].isRemain = true;
    target.stateDatas[self.skillID].remainTime = STATE_DESTROY_DURATION;
    
    NSMutableArray<Block*>* checkBlocks = [[NSMutableArray alloc] init];
    //find blocks in effect range and uncheck them.
    for (int y = 0; y<LINE_LENGTH; y++) {
        for(int x = 0;x<LINE_LENGTH;x++){
                Block* block = [target.board getBlockX:x Y:y];
            if (block.isChecked) {
                [checkBlocks addObject:block];
            }
            
        }
    }
    
    int maxHitPlace = checkBlocks.count >= 3 ? 3 : (int)checkBlocks.count;
    for (int n = 0; n < maxHitPlace; n++) {
        int randomIndex = (int)(arc4random()%checkBlocks.count);
        Block* block = [checkBlocks objectAtIndex:randomIndex];
        block.isDestroyed = true;
        block.isChecked = false;
    }
    
}

@end
