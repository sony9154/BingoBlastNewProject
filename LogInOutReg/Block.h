//
//  Block.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/27.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Block_Attribute_Count 3

typedef enum BlockAttributeType{
    BlockAttributeDestroy = 0,
    BlockAttributeSeal,
    BlockAttributeAid
}BlockAttributeType;

@interface Block : NSObject

@property BOOL isChecked;
@property BOOL isUnvalid;
@property BOOL isDestroyed;
@property BOOL isSealed;
@property int number;
@property BlockAttributeType attribute;
//@property int state;

@end
