//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMusicalInstrument.h"

@implementation XMusicalInstrument

-(id)init:(UInt32)type{
    if(self = [super init]){
        self.type = type;
        self.soundFiles = [NSMutableArray array];
    }
    return self;
}

-(void)addSoundFileByName:(NSString*)soundName
                 fileName:(NSString*)fileName
                  fileExt:(NSString*)fileExt
                fileIndex:(int)fileIndex
{
    XSoundFile* soundFile = [[XSoundFile alloc] initWithName:soundName
                                                    fileName:fileName
                                                     fileExt:fileExt
                                                   fileIndex:fileIndex];
    [self.soundFiles addObject:soundFile];
}

-(XSoundFile*)getSoundFileByIndex:(int)fileIndex{
    return self.soundFiles[fileIndex];
}

-(void)removeAllSoundFiles{
    for (int i=0; i<self.soundFiles.count; i++) {
        XSoundFile* soundFile = self.soundFiles[i];
        [soundFile xDispose];
    }
    [self.soundFiles removeAllObjects];
}

-(int)soundCount{
    return (int)self.soundFiles.count;
}
@end