//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import "XMidiNoteMessage.h"
#import "OpenALSupport.h"
#import "XMusicalInstrumentsManager.h"
#import "XMusicalInstrument.h"
#import "XSoundFile.h"

#define MAX_BUFFERS 128

@class XMidiNoteMessage;

@protocol XOpenALPlayerDelegate <NSObject>
@optional
+ (void)playingSoundNote:(XMidiNoteMessage *)xMidiNoteMessage;
@end

@interface XOpenALPlayer : NSObject <XOpenALPlayerDelegate>

+(id<XOpenALPlayerDelegate>)getDelegate;
+(void)setDelegate:(id<XOpenALPlayerDelegate>)d;

//初始化
+ (void)xInit;
//释放资源
+ (void)xDispose;

//添加声音缓冲
+ (void)addSoundBufferWithSoundFile:(XSoundFile*)soundFile;
//播放声音
+ (void)playSound:(XMidiNoteMessage *)xMidiNoteMessage;
@end

