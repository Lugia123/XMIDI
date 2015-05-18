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
        [self initByUrl:midiUrl];
    }
    return self;
}

- (id)initWithData:(NSData*)data{
    if(self = [super init]){
        [self initByData:data];
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

-(void)initByData:(NSData*)data{
    MusicSequence sequence;
    OSStatus err = NewMusicSequence(&sequence);
    if (err != 0){
        [XFunction writeLog:@"NewMusicSequence() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    
    self.sequence = sequence;
    err = MusicSequenceFileLoadData(self.sequence, (__bridge CFDataRef)(data), kMusicSequenceFile_MIDIType, 0);
    if (err != 0){
        [XFunction writeLog:@"MusicSequenceFileLoad() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    
    [self initTempoTrack];
    [self initTrack];
    [self initMusicTotalTimeStamp];
}

-(void)initByUrl:(NSURL*)midiUrl{
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
    [self initMusicTotalTimeStamp];
}

-(void)initTempoTrack{
    MusicTrack tempoTrack;
    OSStatus err = MusicSequenceGetTempoTrack(self.sequence, &tempoTrack);
    if (err != 0){
        [XFunction writeLog:@"MusicSequenceGetIndTrack() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    
    NSMutableArray* tempoEvents = [NSMutableArray array];
    self.xTempoTrack = [[XMidiTrack alloc] init:tempoTrack];
    
//    NSLog(@"loopDuration:%f",self.xTempoTrack.loopDuration);
//    NSLog(@"numberOfLoops:%d",(int)self.xTempoTrack.numberOfLoops);
//    NSLog(@"offset:%f",self.xTempoTrack.offset);
//    NSLog(@"muted:%d",self.xTempoTrack.muted);
//    NSLog(@"solo:%d",self.xTempoTrack.solo);
//    NSLog(@"length:%f",self.xTempoTrack.length);
//    NSLog(@"timeResolution:%d",self.xTempoTrack.timeResolution);
    
    for (int i=0; i<[[[self.xTempoTrack eventIterator]childEvents]count]; i++) {
        XMidiEvent* event = [[self.xTempoTrack eventIterator]childEvents][i];
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

-(void)initMusicTotalTimeStamp{
    //计算整首歌曲时间
    //获取歌曲最大timeStamp
    self.musicTotalTime = 0;
    double maxTimeStamp = 0;
    for (int i = 0; i< self.tracks.count; i++) {
        XMidiTrack* track = self.tracks[i];
        if (track.eventIterator.childEvents.count <= 0){
            continue;
        }
        XMidiEvent* lastEvent = track.eventIterator.childEvents[track.eventIterator.childEvents.count - 1];
        if (maxTimeStamp < lastEvent.timeStamp){
            maxTimeStamp = lastEvent.timeStamp;
        }
    }
    
    //根据歌曲绝对时间和bpm计算歌曲真实播放时间
    //歌曲绝对时间是60bpm
    //所以：真实时间 = 绝对时间 / bpm * 60
    //但由于整首歌曲的bpm不是固定值，所以需要按时间段逐个计算
    //公式: 真实时间 = T1 / T1(bpm) * 60 + T2 / T2(bpm) * 60 + .... + Tn / Tn(bpm) * 60
    double playTimeStamp = 0;
    while (playTimeStamp < maxTimeStamp) {
        double bpm = [XMidiEvent getTempoBpmInTimeStamp:playTimeStamp];
        playTimeStamp += 1 / 60.0 / 60.0 * bpm;
        self.musicTotalTime += 1 / 60.0;
    }
    
//    NSLog(@"max:%f play:%f  total:%f",maxTimeStamp,playTimeStamp,self.musicTotalTime);
}

@end