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
#import "XMidiNoteMessage.h"
#import "OpenALSupport.h"

#define MAX_BUFFERS 128

@class XMidiNoteMessage;

@interface XOpenALPlayer : NSObject
+ (void)addSoundBufferWithFileName:(NSString*)fileName fileExt:(NSString*)fileExt fileIndex:(int)fileIndex;
+ (void)playSound:(XMidiNoteMessage *)xMidiNoteMessage;
@end