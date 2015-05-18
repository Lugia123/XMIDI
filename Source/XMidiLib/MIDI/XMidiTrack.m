//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiTrack.h"

@implementation XMidiTrack
- (id)init:(MusicTrack)musicTrack{
    if(self = [super init]){
        self.playEventIndex = 0;
        self.musicTrack = musicTrack;
        [self initEvent];
    }
    return self;
}

-(void)initEvent{
    self.eventIterator = [[XMidiEventIterator alloc]init:self];
}

- (BOOL)doesLoop
{
    return self.loopDuration > 0;
}

- (SInt32)numberOfLoops
{
    return self.loopInfo.numberOfLoops;
}

- (MusicTimeStamp)loopDuration
{
    return self.loopInfo.loopDuration;
}

- (MusicTrackLoopInfo)loopInfo
{
    MusicTrackLoopInfo info;
    UInt32 infoSize = sizeof(info);
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_LoopInfo, &info, &infoSize);
    if (err != 0) {
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return info;
}

- (MusicTimeStamp)offset
{
    MusicTimeStamp offset = 0;
    UInt32 offsetLength = sizeof(offset);
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_OffsetTime, &offset, &offsetLength);
    if (err != 0) {
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return offset;
}

- (BOOL)isMuted
{
    Boolean isMuted = FALSE;
    UInt32 isMutedLength = sizeof(isMuted);
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_MuteStatus, &isMuted, &isMutedLength);
    if (err != 0) {
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return isMuted ? YES : NO;
}

- (BOOL)isSolo
{
    Boolean isSolo = FALSE;
    UInt32 isSoloLength = sizeof(isSolo);
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_SoloStatus, &isSolo, &isSoloLength);
    if (err != 0) {
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return isSolo ? YES : NO;
}

-(MusicTimeStamp)length{
    MusicTimeStamp outData;
    UInt32 ioLenght;
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_TrackLength, &outData, &ioLenght);
    if (err != 0){
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return outData;
}

- (SInt16)timeResolution
{
    SInt16 resolution = 0;
    UInt32 resolutionLength = sizeof(resolution);
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_TimeResolution, &resolution, &resolutionLength);
    if (err != 0) {
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return resolution;
}
@end