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
#import "XMidiEvent.h"
#import "XMidiTrack.h"

@class XMidiTrack;

@interface XMidiEventIterator : NSObject
enum eventTypes{
    trackEvent,
    tempoTrackEvent
};

@property (nonatomic) MusicEventIterator eventIterator;
@property (nonatomic) NSMutableArray* childEvents;
@property (nonatomic) enum eventTypes* eventType;


-(id)init:(XMidiTrack*)track;
@end