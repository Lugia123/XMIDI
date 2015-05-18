//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#ifndef XColor_XSoundEngin_h
#define XColor_XSoundEngin_h


#endif


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface XOpenAL : NSObject

//初始化
+ (void)xInit;
//释放资源
+ (void)xDispose;
@end