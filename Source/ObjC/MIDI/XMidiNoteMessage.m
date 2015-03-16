//
//  XMidiSequence.m
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiNoteMessage.h"

@implementation XMidiNoteMessage
-(id)init:(MIDINoteMessage*)noteMessage{
    if(self = [super init]){
        //timeStamp 出现时间
        //channel 乐器
        //note 音高 60为中央C
        //velocity 力度
        //duration 持续时间
        self.channel = noteMessage->channel;
        self.note = noteMessage->note;
        self.velocity = noteMessage->velocity;
        self.releaseVelocity = noteMessage->releaseVelocity;
        self.duration = noteMessage->duration;
        self.duration = [[[NSString alloc]initWithFormat:@"%.3f",self.duration] floatValue];
        
        // Panning ranges between C3 (-50%) to G5 (+50%)
        if (self.note < 48) self.panning = -50.0f;
        if (self.note >= 48 && self.note < 80) self.panning = ((((self.note - 48.0f) / (79 - 48)) * 200.0f) - 100.f) / 2.0f;
        if (self.note >= 80) self.panning = 50.0f;
    }
    return self;
}

-(int)soundFileIndex
{
    int offset = self.note - 60;
    int index = [XSoundFile centerCIndex] + offset;
    
    if (index > [XSoundFile soundCount] - 1 || index < 0){
        NSLog(@"sound over index:%d",index);
        return -1;
    }
    return index;
}
@end