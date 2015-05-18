//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFunction.h"
#import "XSoundFile.h"

@class XSoundFile;

@interface XMusicalInstrument : NSObject
enum
{
    xMusicalInstrumentType_Pinao = 0
};

@property (nonatomic) UInt32 type;
@property (nonatomic) NSMutableArray* soundFiles;
@property (nonatomic) int centerCIndex;
@property (nonatomic) int soundCount;

-(id)init:(UInt32)type;
-(void)addSoundFileByName:(NSString*)soundName
                 fileName:(NSString*)fileName
                  fileExt:(NSString*)fileExt
                fileIndex:(int)fileIndex;
-(XSoundFile*)getSoundFileByIndex:(int)fileIndex;
-(void)removeAllSoundFiles;
@end
