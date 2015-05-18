//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

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

- (id)init:(MusicTrack)musicTrack;

/**
 *  Whether the track is set to loop.
 */
@property (nonatomic, readonly) BOOL doesLoop;

/**
 * The number of times to play the designated portion of the music track. By default, a music track plays once.
 *
 *  This is a shortcut to the numberOfLoops member of the loopInfo property.
 */
@property (nonatomic) SInt32 numberOfLoops;

/**
 *  The point in a MIDI track, measured in beats from the end of the MIDI track, at which to begin playback during looped playback.
 *  That is, during looped playback, a MIDI track plays from (length – loopDuration) to length.
 *
 *  This is a shortcut to the loopDuration member of the loopInfo property.
 */
@property (nonatomic) MusicTimeStamp loopDuration;

/**
 *  The loop info for the track.
 */
@property (nonatomic) MusicTrackLoopInfo loopInfo;

/**
 *  A MIDI track’s start time in terms of beat number. By default this value is 0.
 */
@property (nonatomic) MusicTimeStamp offset;

/**
 *  Whether or not the MIDI track is muted.
 */
@property (nonatomic, getter = isMuted) BOOL muted;

/**
 *  Whether or not the MIDI track is soloed.
 */
@property (nonatomic, getter = isSolo) BOOL solo;

/**
 *  The length of the MIDI track.
 */
-(MusicTimeStamp)length;

/**
 *  The time resolution for a sequence of MIDI events. For example, this value can indicate the time resolution that was specified
 *  by the MIDI file used to construct a sequence.
 *
 *  If you create a MIDI sequence programmatically, the value is set to 480. If you create a MIDI sequence from a MIDI file,
 *  the value is set to the time resolution specified in the MIDI file.
 */
@property (nonatomic, readonly) SInt16 timeResolution;
@end