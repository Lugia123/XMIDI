//
//  XSoundEngin.m
//  XColor
//
//  Created by Lugia on 14/12/25.
//  Copyright (c) 2014年 Freedom. All rights reserved.
//

#import "XOpenALPlayer.h"

// Tracks an OpenAL source.
typedef struct
{
    ALuint sourceId;
    ALuint bufferId;
    int fileIndex;
    int playCount;
    void *data;
}
Source;

@implementation XOpenALPlayer
static Source _sources[MAX_BUFFERS];

+(void)addSoundBufferWithFileName:(NSString*)fileName fileExt:(NSString*)fileExt fileIndex:(int)fileIndex
{
    alGetError();  // clear any errors
    
    int t = fileIndex;
    
    alGenSources(1, &_sources[t].sourceId);
    
    ALenum err;
    if ((err = alGetError()) != AL_NO_ERROR)
    {
        [XFunction writeLog:@"Error generating OpenAL source: %x", err];
        return;
    }
    
    _sources[t].playCount = 0;
    _sources[t].fileIndex = fileIndex;
    
    //create  buffer
    alGenBuffers(1, &_sources[t].bufferId);
    if ((err = alGetError()) != AL_NO_ERROR)
    {
        [XFunction writeLog:@"Error generating OpenAL buffer: %x", err];
        return;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName
                                         withExtension:fileExt];
    if (url == nil)
    {
        [XFunction writeLog:@"Could not find file '%@'", fileName];
        return;
    }
    
    ALenum format;
    ALsizei size;
    ALsizei freq;
    _sources[t].data = GetOpenALAudioData((__bridge CFURLRef)url, &size, &format, &freq);
    
    if (_sources[t].data == NULL)
    {
        [XFunction writeLog:@"Error loading sound"];
        return;
    }
    
    alBufferDataStaticProc(_sources[t].bufferId, format, _sources[t].data, size, freq);
    
    //assign the buffer to this source
    alSourcei(_sources[t].sourceId, AL_BUFFER, _sources[t].bufferId);
    
    //属性
    alSourcei(_sources[t].sourceId, AL_LOOPING, AL_FALSE);
    alSourcef(_sources[t].sourceId, AL_PITCH, 1.0f);//音高
    alSourcef(_sources[t].sourceId, AL_REFERENCE_DISTANCE, 100.0f);
    
    if ((err = alGetError()) != AL_NO_ERROR)
    {
        [XFunction writeLog:@"Error attaching audio to buffer: %x", err];
    }
}

+ (void)playSound:(XMidiNoteMessage *)xMidiNoteMessage {
    int t = [xMidiNoteMessage soundFileIndex];
    if (_sources[t].playCount + 1 > 10000){
        _sources[t].playCount = 0;
    }
    _sources[t].playCount += 1;
    int playCount = _sources[t].playCount;
    
    ALint sourceState;
    alGetSourcei(_sources[t].sourceId, AL_SOURCE_STATE, & sourceState);
    if (sourceState == AL_PLAYING){
        alSourceStop(_sources[t].sourceId);
    }
    
    //按力度计算
    int maxdB = 54;//声音对应力度差值，越大力度差距导致的声音大小差距越大
    Float32 velocity = xMidiNoteMessage.velocity;
    if (velocity > 100){
        //防止音过高
        velocity = 100;
    }
    Float32 rate = velocity / 127.0f;
    int dB = maxdB * rate;
    Float32 vol = 1.0f / powf(2,(int)((maxdB - dB) / 6));
    if (vol > 1) vol = 1;
    alSourcef(_sources[t].sourceId, AL_GAIN, vol);//设置音量大小，1.0f表示最大音量
    
    float sourcePos[] = { xMidiNoteMessage.panning, 0.0f, 0.0f };
    alSourcefv(_sources[t].sourceId, AL_POSITION, sourcePos);

    //play
    alSourcePlay(_sources[t].sourceId);
    
    //fadeOut
    Float32 duration = xMidiNoteMessage.duration;
    if (duration < 0){
        duration = 0;
    }
    double delayInSeconds = duration*0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //逐渐减小声音
        [self fadeOutWith:t
                playCount:playCount
            totalDuration:delayInSeconds
                totalStep:5
              currentStep:1
                 startVol:vol];
    });
}

+(void)fadeOutWith:(int)soundIndex
         playCount:(int)playCount
     totalDuration:(Float32)totalDuration
         totalStep:(int)totalStep
       currentStep:(int)currentStep
          startVol:(Float32)startVol
{
    int t = soundIndex;
    
    //再次播放 音量已经被重置
    if (playCount != _sources[t].playCount){
        return;
    }
    
    //逐渐减小声音
    alSourcef(_sources[t].sourceId, AL_GAIN, startVol * (totalStep - currentStep) / totalStep);
    
    int step = currentStep + 1;
    double delayInSeconds = totalDuration > 0.2 ? totalDuration : 0.2 / totalStep;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fadeOutWith:t
                playCount:playCount
            totalDuration:totalDuration
                totalStep:totalStep
              currentStep:step
                 startVol:startVol];
    });
}
@end
