//
//  XMidiSequence.h
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#ifndef XColor_XMidiSequence_h
#define XColor_XMidiSequence_h


#endif

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XFunction.h"
#import "XOpenALPlayer.h"

@interface XSoundFile : NSObject
@property (nonatomic) NSString* soundName;
@property (nonatomic) NSString* fileName;
@property (nonatomic) NSString* fileExt;
@property (nonatomic) int fileIndex;

@property (nonatomic) UInt32 bufferLen;
@property (nonatomic) char* buffer;

+(void)initSoundData;
+(int) soundCount;
+(int) centerCIndex;
@end
