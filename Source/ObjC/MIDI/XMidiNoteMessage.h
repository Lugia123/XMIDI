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
#import "XMidiSequence.h"
#import "XSoundFile.h"

@interface XMidiNoteMessage : NSObject
@property (nonatomic) UInt8 channel;
@property (nonatomic) UInt8 note;
@property (nonatomic) UInt8 velocity;
@property (nonatomic) UInt8 releaseVelocity;	// was "reserved". 0 is the correct value when you don't know.
@property (nonatomic) Float32 duration;
@property (nonatomic) float panning;    // < 0 is left, 0 is center, > 0 is right

-(id)init:(MIDINoteMessage*)noteMessage;
-(int)soundFileIndex;
@end
