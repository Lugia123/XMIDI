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
#import "XMidiTrack.h"
#import "XFunction.h"
#import "XSoundFile.h"


@interface XMidiSequence : NSObject
@property (nonatomic) NSMutableArray* tracks;
@property (nonatomic) MusicSequence sequence;

+(NSMutableArray*)getTempoEvents;
+(void)setTempoEvents:(NSMutableArray*)newVal;

- (UInt32)trackCount;
- (id)init:(NSURL*)midiUrl;
@end