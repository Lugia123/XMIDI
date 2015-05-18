//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMusicalInstrumentsManager.h"

//
//  乐器中心
//
static NSMutableArray* musicalInstruments;
static BOOL isDisposed = false;

@implementation XMusicalInstrumentsManager

+(void)xInit{
    isDisposed = false;
    musicalInstruments = [NSMutableArray array];
    [self initPianoSoundData];
}

+(void)xDispose{
    isDisposed = true;
    for (int i=0; i<musicalInstruments.count; i++) {
        XMusicalInstrument* musicalInstrument = musicalInstruments[i];
        [musicalInstrument removeAllSoundFiles];
    }
    [musicalInstruments removeAllObjects];
}

+(void)initPianoSoundData{
    XMusicalInstrument* musicalInstrument = [[XMusicalInstrument alloc] init:xMusicalInstrumentType_Pinao];
    NSString* ext = @"wav";
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
            
            [musicalInstrument addSoundFileByName:soundName fileName:fileName fileExt:ext fileIndex:fileIndex];
            if ([soundName  isEqual: @"C3"]){
                musicalInstrument.centerCIndex = fileIndex;
            }

            fileNum += 1;
            fileIndex += 1;
        }
    }
    
    [musicalInstruments addObject:musicalInstrument];
}

+(XMusicalInstrument*)getMusicalInstrumentByType:(int)type{
    for (int i=0; i<musicalInstruments.count; i++) {
        XMusicalInstrument* musicalInstrument = musicalInstruments[i];
        if (musicalInstrument.type == type){
            return musicalInstrument;
        }
    }
    return nil;
}

+(int)getCenterCIndexByType:(int)type{
    if (isDisposed){
        return 0;
    }
    XMusicalInstrument* musicalInstrument = [self getMusicalInstrumentByType:type];
    if (musicalInstrument == nil){
        return 0;
    }
    return musicalInstrument.centerCIndex;
}

+(int)getSoundCountByType:(int)type{
    if (isDisposed){
        return 0;
    }
    XMusicalInstrument* musicalInstrument = [self getMusicalInstrumentByType:type];
    if (musicalInstrument == nil){
        return 0;
    }
    return musicalInstrument.soundCount;
}

+(XSoundFile*)getSoundFileByType:(int)type fileIndex:(int)fileIndex{
    if (isDisposed){
        return nil;
    }
    XMusicalInstrument* musicalInstrument = [self getMusicalInstrumentByType:type];
    if (musicalInstrument == nil){
        return nil;
    }
    return [musicalInstrument getSoundFileByIndex:fileIndex];
}
@end