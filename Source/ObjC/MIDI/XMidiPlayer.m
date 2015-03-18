//
//  XMidiSequence.m
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiPlayer.h"

@implementation XMidiPlayer
-(id)init{
    if(self = [super init]){
        self.isPlayTimerEnabled = true;
        [self playTimer];
    }
    return self;
}

- (void)initMidi:(NSURL*)midiUrl{
    self.isPaused = true;
    self.playTimeStamp = 0;
    self.midiSequence = [[XMidiSequence alloc] init:midiUrl];
}

-(void)closePlayer{
    self.isPlayTimerEnabled = false;
    self.isPaused = true;
    self.midiSequence = NULL;
}

-(void)pause{
    self.isPaused = true;
}

-(void)play{
    self.isPaused = false;
    self.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
}

-(void)playTimer
{
    double timeSinceLast = [[NSDate date] timeIntervalSince1970] - self.lastUpdateTime;
    self.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    
    double delayInSeconds = 1 / 60.0;
    if (!self.isPaused){
        //按bgm速率播放
        double bpm = [XMidiEvent getTempoBpmInTimeStamp:self.playTimeStamp];
        self.playTimeStamp += timeSinceLast / 60.0 * bpm;
        [self playSound];
        //防止溢出
        if (self.playTimeStamp > 100000.0f){
            self.playTimeStamp = 0;
        }
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.isPlayTimerEnabled){
            [self playTimer];
        }
    });
}

-(void)playSound{
    if (self.midiSequence == NULL){
        return;
    }
    
    if (self.midiSequence.tracks.count <= 0){
        return;
    }
    
    for (int i = 0; i<self.midiSequence.tracks.count; i++) {
        XMidiTrack* track = self.midiSequence.tracks[i];
        for (int index = track.playEventIndex; index<track.playEventIndex + 10; index++) {
            if (index < track.playEventIndex || index >= track.eventIterator.childEvents.count){
                continue;
            }
            
            XMidiEvent* event = track.eventIterator.childEvents[index];
            if (self.playTimeStamp >= event.timeStamp && !event.isPlayed){
                track.playEventIndex = index;
                [event playEvent];
            }
        }
    }
}
@end