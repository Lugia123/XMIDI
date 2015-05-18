//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XFunction.h"

@interface XMidiTempoEvent : NSObject
@property (nonatomic) MusicTimeStamp timeStamp;
@property (nonatomic) MusicEventType type;
@property (nonatomic) NSData* data;

-(id)init:(MusicTimeStamp)timeStamp type:(MusicEventType)type data:(NSData*)data;
- (int)bpm;
@end
