//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiTempoEvent.h"

@implementation XMidiTempoEvent
-(id)init:(MusicTimeStamp)timeStamp
     type:(MusicEventType)type
     data:(NSData*)data{
    if(self = [super init]){
        self.timeStamp = [[[NSString alloc]initWithFormat:@"%.3f",timeStamp] floatValue];
        self.type = type;
        self.data = [data mutableCopy];
    }
    return self;
}

#pragma mark - Properties
- (int)bpm
{
    ExtendedTempoEvent *tempoEvent = (ExtendedTempoEvent *)[self.data bytes];
    return tempoEvent->bpm;
}
@end