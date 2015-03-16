//
//  XMidiSequence.m
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XSoundFile.h"
//中间C键所在索引
static int centerCIndex;
//总音阶数
static int soundCount;

@implementation XSoundFile
+(void)initSoundData{
    NSString* ext = @"caf";
    NSArray* notes = [[NSArray alloc] initWithObjects:@"C",@"C#",@"D",@"D#",@"E",@"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
    int fileNum = 24;
    int fileIndex = 0;
    for (int i=0; i<=6; i++) {
        for (int j=0; j<[notes count]; j++) {
            NSString* fileNumStr = [[NSString alloc]initWithFormat:@"%d",fileNum];
            if (fileNum <= 99){
                fileNumStr = [[NSString alloc] initWithFormat:@"0%@", fileNumStr];
            }
            
            NSString* soundName = [[NSString alloc]initWithFormat:@"%@%d",notes[j],i];
            NSString* fileName = [[NSString alloc]initWithFormat:@"%@_%@KM56_M",fileNumStr,soundName];
            
            [XOpenALPlayer addSoundBufferWithFileName:fileName fileExt:ext fileIndex:fileIndex];
            if ([soundName  isEqual: @"C3"]){
                centerCIndex = fileIndex;
            }
//            NSLog(@"%d %@",i,fileName);
            
            fileNum += 1;
            fileIndex += 1;
        }
    }
    
    soundCount = fileIndex;
    
//    NSLog(@"centerCIndex:%d",centerCIndex);
}

+(int) soundCount{
    return soundCount;
}

+(int) centerCIndex{
    return centerCIndex;
}
@end