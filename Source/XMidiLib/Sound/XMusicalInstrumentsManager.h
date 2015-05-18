//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFunction.h"
#import "XSoundFile.h"
#import "XMusicalInstrument.h"

@class XMusicalInstrument;
@class XSoundFile;

//
//  乐器中心
//
@interface XMusicalInstrumentsManager : NSObject
//初始化
+(void) xInit;
//释放
+(void) xDispose;

//获取中央C索引号
+(int)getCenterCIndexByType:(int)type;
//获取声音总数
+(int)getSoundCountByType:(int)type;
//获取声音
+(XSoundFile*)getSoundFileByType:(int)type fileIndex:(int)fileIndex;
@end
