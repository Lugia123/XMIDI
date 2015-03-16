//
//  XMidiSequence.m
//  XColor
//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XFunction.h"

@implementation XFunction
+ (void)writeLog:(NSString*)log,...{
    va_list args;
    va_start(args,log);
    NSLogv(log,args);
    va_end(args);
}
@end