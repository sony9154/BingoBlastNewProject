//
//  callNumbers.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/06.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "CallNumbers.h"

@implementation CallNumbers
{
    int nowNumbers[CALL_NUMBER_COUNT];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //create array of all Numbers
        self.allNumbers = [[NSMutableArray alloc] init];
        for(int n = 1; n <= ALL_NUMBER_COUNT; n++){
            [self.allNumbers addObject:[NSNumber numberWithInt:n]];
        }
        
        //put random numbers into array of now called numbers
        for(int n = 0; n < CALL_NUMBER_COUNT; n++){
//            int randomIndex = arc4random() % self.allNumbers.count;
//            nowNumbers[n] = [[self.allNumbers objectAtIndex:randomIndex] intValue];
//            [self.allNumbers removeObjectAtIndex:randomIndex];
            
            nowNumbers[n] = -1;
        }
        
    }
    return self;
}


//- (void) turnNumbers{
//    
//    for(int n = CALL_NUMBER_COUNT-1; n > 0; n--){
//        nowNumbers[n] = nowNumbers[n-1];
//    }
//    if(self.allNumbers.count >0){
//        int randomIndex = arc4random() % self.allNumbers.count;
//        nowNumbers[0] = [[self.allNumbers objectAtIndex:randomIndex] intValue];
//        [self.allNumbers removeObjectAtIndex:randomIndex];
//    }else{
//        nowNumbers[0] = -1;
//    }
//    
//}

- (void) turnNumbers{

    for(int n = CALL_NUMBER_COUNT-1; n > 0; n--){
        nowNumbers[n] = nowNumbers[n-1];
    }
    if(self.allNumbers.count >0){
        int randomIndex = arc4random() % self.allNumbers.count;
        nowNumbers[0] = [[self.allNumbers objectAtIndex:randomIndex] intValue];
        [self.allNumbers removeObjectAtIndex:randomIndex];
    }else{
        nowNumbers[0] = -1;
    }

}

- (void) turnNumbersWithNewNumber:(int)newNumber{
    
    for(int n = CALL_NUMBER_COUNT-1; n > 0; n--){
        nowNumbers[n] = nowNumbers[n-1];
    }

    if(self.allNumbers.count >0){
        nowNumbers[0] = newNumber;
    }else{
        nowNumbers[0] = -1;
    }
    
}

- (int) getNumber:(int)index{
    return nowNumbers[index];
}

- (void) setNumberWithIndex:(int)index to:(int)number{
    nowNumbers[index] = number;
}

- (int) checkNumber:(int)checkedNumber{
    
    for(int n = 0; n < CALL_NUMBER_COUNT; n++){
        if(nowNumbers[n] == checkedNumber){
//            nowNumbers[n] = -1;
            return n;
        }
    }
    return -1;
    
}

- (BOOL) isNoNumber{
    
    //whether called numbers exist
    for(int n = 0; n < CALL_NUMBER_COUNT; n++){
        if(nowNumbers[n] != -1)return false;
    }
    
    //whether uncalled number remaining
    if(self.allNumbers.count != 0)return false;
    
    return true;
}

@end
