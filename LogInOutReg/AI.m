//
//  AI.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/19.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "AI.h"

@implementation AI

- (instancetype) initWithPlayer:(Player*)player Strength:(AIStrengthConfig)strength{
    self = [super init];
    if(self) {
        aiPlayer = player;
        aiStrength = strength;
        self.missingRate = 0;
    }
    return self;
    
}

- (Block*)pressBlock:(CallNumbers*)callNumbers{
    
    int randomNumber = (int)(arc4random() % 100);
    //    NSLog([NSString stringWithFormat:@"%i",randomNumber]);
    NSMutableArray* correctBlocks = [[NSMutableArray alloc] init];
    switch (aiStrength) {
        case AIStrengthEasy:
            self.missingRate = MISSING_RATE_EASY;
            break;
        case AIStrengthNormal:
            self.missingRate = MISSING_RATE_NORMAL;
            break;
        case AIStrengthHard:
            self.missingRate = MISSING_RATE_HARD;
            break;
        default:
            break;
    }
    
    BOOL isCorrect = randomNumber >= self.missingRate;
    Block* pressedBlock = nil;
    
    if(isCorrect){
        //press a correct block
        for(int y = 0; y < LINE_LENGTH; y++){
            for(int x = 0; x <LINE_LENGTH; x++){
                
                Block* block = [aiPlayer.board getBlockX:x Y:y];
                int number = block.number;
                
                if([callNumbers checkNumber:number] != -1 && !block.isSealed){
                    [correctBlocks addObject:block];
                }
                
                //                for (int n = 0; n < CALL_NUMBER_COUNT; n++) {
                //                    if(number == [callNumbers getNumber:n]){
                //                        [correctBlocks addObject:block];
                //                    }
                //                }
                
            }
        }
        
        if(correctBlocks.count > 0){
            
            int randomIndex = arc4random()%correctBlocks.count;
            pressedBlock = [correctBlocks objectAtIndex:randomIndex];
            int matchIndex = [callNumbers checkNumber:pressedBlock.number];
            [callNumbers setNumberWithIndex:matchIndex to:-1];
            pressedBlock.isChecked = true;
            aiPlayer.skillDatas[pressedBlock.attribute].power++;
            
        }
        
    }else{
        //press a wrong block
        aiPlayer.penalty +=50;
        
    }
    
    
    return pressedBlock;
    
}

@end
