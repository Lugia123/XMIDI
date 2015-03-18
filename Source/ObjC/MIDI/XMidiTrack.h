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
#import "XMidiEventIterator.h"
#import "XFunction.h"

@class XMidiEventIterator;

@interface XMidiTrack : NSObject
@property (nonatomic) MusicTrack musicTrack;
@property (nonatomic) XMidiEventIterator* eventIterator;

//当前播放到第几个事件
@property (nonatomic) int playEventIndex;

-(MusicTimeStamp)length;

- (id)init:(MusicTrack)musicTrack;
@end