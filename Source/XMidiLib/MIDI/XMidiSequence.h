//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XMidiTrack.h"
#import "XFunction.h"

@class XMidiTrack;

@interface XMidiSequence : NSObject
/**
 *  XMidiTrack Array
 */
@property (nonatomic) NSMutableArray* tracks;
/**
 *  Tempo Track
 */
@property (nonatomic) XMidiTrack* xTempoTrack;
@property (nonatomic) MusicSequence sequence;
@property (nonatomic) double musicTotalTime;

+(NSMutableArray*)getTempoEvents;
+(void)setTempoEvents:(NSMutableArray*)newVal;

- (UInt32)trackCount;
- (id)init:(NSURL*)midiUrl;
- (id)initWithData:(NSData*)data;
@end