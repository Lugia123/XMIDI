//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XSoundFile.h"

@implementation XSoundFile

-(id)initWithName:(NSString*)soundName
         fileName:(NSString*)fileName
          fileExt:(NSString*)fileExt
        fileIndex:(int)fileIndex
{
    if(self = [super init]){
        self.soundName = soundName;
        self.fileName = fileName;
        self.fileExt = fileExt;
        self.fileIndex = fileIndex;
        self.playCount = 0;
        [self initOpenALBuffer];
    }
    return self;
}

-(void)xDispose{
    free(self.data);
}

-(void)initOpenALBuffer{
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.fileName
                                         withExtension:self.fileExt];
    if (url == nil)
    {
        [XFunction writeLog:@"Could not find file '%@'", self.fileName];
        return;
    }
    
    ALenum tmpFormat;
    ALsizei tmpSize;
    ALsizei tmpFreq;
    self.data = GetOpenALAudioData((__bridge CFURLRef)url, &tmpSize, &tmpFormat, &tmpFreq);
    self.size = tmpSize;
    self.format = tmpFormat;
    self.freq = tmpFreq;
    
    if (self.data == NULL)
    {
        [XFunction writeLog:@"Error loading sound"];
        return;
    }
    
    [XOpenALPlayer addSoundBufferWithSoundFile:self];
}
@end