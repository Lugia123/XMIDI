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

@interface XMidiTempoEvent : NSObject
@property (nonatomic) MusicTimeStamp timeStamp;
@property (nonatomic) MusicEventType type;
@property (nonatomic) NSData* data;

-(id)init:(MusicTimeStamp)timeStamp type:(MusicEventType)type data:(NSData*)data;
- (int)bpm;
@end
