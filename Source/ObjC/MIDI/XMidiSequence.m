//
//  XMidiSequence.m
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiSequence.h"

//速率
static NSMutableArray* tempoChildEvents;


@implementation XMidiSequence

- (UInt32)trackCount{
    UInt32 trackCount = 0;
    OSStatus err = MusicSequenceGetTrackCount(self.sequence, &trackCount);
    if (err != 0){
        [XFunction writeLog:@"MusicSequenceGetTrackCount() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return trackCount;
}

- (id)init:(NSURL*)midiUrl{
    if(self = [super init]){
        [self initWithUrl:midiUrl];
    }
    return self;
}

+(NSMutableArray*)getTempoEvents{
    return tempoChildEvents;
}

+(void)setTempoEvents:(NSMutableArray*)newVal{
    if (tempoChildEvents != newVal){
        tempoChildEvents = newVal;
    }
}

-(void)initWithUrl:(NSURL*)midiUrl{
    MusicSequence sequence;
    OSStatus err = NewMusicSequence(&sequence);
    if (err != 0){
        [XFunction writeLog:@"NewMusicSequence() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    
    self.sequence = sequence;
    err = MusicSequenceFileLoad(self.sequence, (__bridge CFURLRef)(midiUrl), kMusicSequenceFile_MIDIType, 0);
    if (err != 0){
        [XFunction writeLog:@"MusicSequenceFileLoad() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    
    [self initTempoTrack];
    [self initTrack];
}

-(void)initTempoTrack{
    MusicTrack tempoTrack;
    OSStatus err = MusicSequenceGetTempoTrack(self.sequence, &tempoTrack);
    if (err != 0){
        [XFunction writeLog:@"MusicSequenceGetIndTrack() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    
    NSMutableArray* tempoEvents = [NSMutableArray array];
    XMidiTrack* xTempoTrack = [[XMidiTrack alloc] init:tempoTrack];
    for (int i=0; i<[[[xTempoTrack eventIterator]childEvents]count]; i++) {
        XMidiEvent* event = [[xTempoTrack eventIterator]childEvents][i];
//        NSLog(@"time:%f bpm:%d",[event timeStamp],[event bpm]);
        [tempoEvents addObject:event];
    }
    [XMidiSequence setTempoEvents:tempoEvents];
}

-(void)initTrack{
    self.tracks = [NSMutableArray array];
    int count = [self trackCount];
    for (int i=0; i<count; i++) {
        MusicTrack track;
        OSStatus err = MusicSequenceGetIndTrack(self.sequence, i, &track);
        if (err != 0){
            [XFunction writeLog:@"MusicSequenceGetIndTrack() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
        }
        XMidiTrack* xTrack = [[XMidiTrack alloc] init:track];
        [self.tracks addObject:xTrack];
    }
}

@end