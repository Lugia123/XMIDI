//
//  XSoundEngin.h
//  XColor
//
//  Created by Lugia on 14/12/25.
//  Copyright (c) 2014年 Freedom. All rights reserved.
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

+ (void)initDevice;
+ (void)releaseDevice;
@end