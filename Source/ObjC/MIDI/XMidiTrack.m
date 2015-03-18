//
//  XMidiSequence.m
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiTrack.h"

@implementation XMidiTrack
-(MusicTimeStamp)length{
    MusicTimeStamp outData;
    UInt32 ioLenght;
    OSStatus err = MusicTrackGetProperty(self.musicTrack, kSequenceTrackProperty_TrackLength, &outData, &ioLenght);
    if (err != 0){
        [XFunction writeLog:@"MusicTrackGetProperty() failed with error %d in %s.", err, __PRETTY_FUNCTION__];
    }
    return outData;
}

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
@end