//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//


#import "XMidiEvent.h"

@implementation XMidiEvent
-(id)init:(MusicTimeStamp)timeStamp
     type:(MusicEventType)type
     data:(NSData*)data{
    if(self = [super init]){
        self.timeStamp = [[[NSString alloc]initWithFormat:@"%.3f",timeStamp] floatValue];
        self.type = type;
        self.data = [data mutableCopy];
        self.isPlayed = true;
        
        switch (self.type) {
            case kMusicEventType_NULL:
//                NSLog(@"kMusicEventType_NULL");
                break;
            case kMusicEventType_ExtendedNote:
//                NSLog(@"kMusicEventType_ExtendedNote");
                break;
            case kMusicEventType_ExtendedTempo:
//                NSLog(@"kMusicEventType_ExtendedTempo");
                [self initTempoEvent];
                break;
            case kMusicEventType_User:
//                NSLog(@"kMusicEventType_User");
                break;
            case kMusicEventType_Meta:
//                NSLog(@"kMusicEventType_Meta");
                break;
            case kMusicEventType_MIDINoteMessage:
                [self initNoteEvent];
                break;
            case kMusicEventType_MIDIChannelMessage:
//                NSLog(@"kMusicEventType_MIDIChannelMessage");
                break;
            case kMusicEventType_MIDIRawData:
//                NSLog(@"kMusicEventType_MIDIRawData");
                break;
            case kMusicEventType_Parameter:
//                NSLog(@"kMusicEventType_Parameter");
                break;
            case kMusicEventType_AUPreset:
//                NSLog(@"kMusicEventType_AUPreset");
                break;
            default:
//                NSLog(@"kMusicEventType_Ect");
                break;
        }
    }
    return self;
}

#pragma mark - note

-(void)initNoteEvent{
    self.isPlayed = false;
    
    //timeStamp 出现时间
    //channel 乐器
    //note 音高 60为中央C
    //velocity 力度
    //duration 持续时间
    self.noteMessage = [[XMidiNoteMessage alloc] init:(MIDINoteMessage*)[self.data bytes]];
}

#pragma mark - tempo
- (void)initTempoEvent
{
    ExtendedTempoEvent *tempoEvent = (ExtendedTempoEvent *)[self.data bytes];
    self.bpm = tempoEvent->bpm;
}

+(float)getTempoBpmInTimeStamp:(float)timeStamp{
    NSMutableArray* tempoChildEvents = [XMidiSequence getTempoEvents];
    int bpm = 100;
    if (timeStamp <= 0 && tempoChildEvents.count > 0){
        return [tempoChildEvents[0] bpm];
    }
    for (int i=(int)([tempoChildEvents count] - 1); i>=0; i--) {
        if ([tempoChildEvents[i] timeStamp] <= timeStamp){
            if ([tempoChildEvents[i] bpm] != 0){
                bpm = [tempoChildEvents[i] bpm];
            }
            break;
        }
    }
    return bpm;
}

#pragma mark - event
//播放
-(void)playEvent{
    if (self.type != kMusicEventType_MIDINoteMessage){
        return;
    }
    self.isPlayed = true;
    
    [XOpenALPlayer playSound:self.noteMessage];
}
@end