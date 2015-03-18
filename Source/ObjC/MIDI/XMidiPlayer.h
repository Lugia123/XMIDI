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
#import "XFunction.h"
#import "XMidiSequence.h"


@interface XMidiPlayer : NSObject
@property (nonatomic) XMidiSequence* midiSequence;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isPlayTimerEnabled;
@property (nonatomic) double playTimeStamp;
@property (nonatomic) double lastUpdateTime;

-(void)initMidi:(NSURL*)midiUrl;
-(void)pause;
-(void)play;
-(void)closePlayer;
@end
