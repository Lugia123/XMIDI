//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XOpenALPlayer.h"

@implementation XOpenALPlayer
static id<XOpenALPlayerDelegate> delegate;
static BOOL isDisposed = false;

+(id<XOpenALPlayerDelegate>)getDelegate{
    return delegate;
}

+(void)setDelegate:(id<XOpenALPlayerDelegate>)d{
    delegate = d;
}

+ (void)xInit{
    isDisposed = false;
}
//关闭播放
+ (void)xDispose{
    isDisposed = true;
    int type = xMusicalInstrumentType_Pinao;
    int fileCount = [XMusicalInstrumentsManager getSoundCountByType:type];
    for (int i=0; i<fileCount; i++) {
        XSoundFile* soundFile = [XMusicalInstrumentsManager getSoundFileByType:type fileIndex:i];
        
        if (soundFile == nil){
            continue;
        }
        
        ALint sourceState;
        alGetSourcei(soundFile.sourceId, AL_SOURCE_STATE, & sourceState);
        if (sourceState == AL_PLAYING){
            alSourceStop(soundFile.sourceId);
        }
    }
}

+(void)addSoundBufferWithSoundFile:(XSoundFile*)soundFile
{
    if (isDisposed){
        return;
    }
    
    alGetError();  // clear any errors
    
    ALuint tmpSourceId;
    ALuint tmpBufferId;
    
    alGenSources(1, &tmpSourceId);
    
    soundFile.sourceId = tmpSourceId;
    
    ALenum err;
    if ((err = alGetError()) != AL_NO_ERROR)
    {
        [XFunction writeLog:@"Error generating OpenAL source: %x", err];
        return;
    }
    
    //create  buffer
    alGenBuffers(1, &tmpBufferId);
    if ((err = alGetError()) != AL_NO_ERROR)
    {
        [XFunction writeLog:@"Error generating OpenAL buffer: %x", err];
        return;
    }
    soundFile.bufferId = tmpBufferId;
    
    alBufferDataStaticProc(soundFile.bufferId,
                           soundFile.format,
                           soundFile.data,
                           soundFile.size,
                           soundFile.freq);
    
    //assign the buffer to this source
    alSourcei(soundFile.sourceId, AL_BUFFER, soundFile.bufferId);
    
    //属性
    alSourcei(soundFile.sourceId, AL_LOOPING, AL_FALSE);
    alSourcef(soundFile.sourceId, AL_PITCH, 1.0f);//音高
    alSourcef(soundFile.sourceId, AL_REFERENCE_DISTANCE, 100.0f);
    
    if ((err = alGetError()) != AL_NO_ERROR)
    {
        [XFunction writeLog:@"Error attaching audio to buffer: %x", err];
    }
}

+ (void)playSound:(XMidiNoteMessage *)xMidiNoteMessage {
    if (isDisposed){
        return;
    }
    
    int type = xMusicalInstrumentType_Pinao;
    int fileIndex = [xMidiNoteMessage soundFileIndex];
    XSoundFile* soundFile = [XMusicalInstrumentsManager getSoundFileByType:type fileIndex:fileIndex];
    
    if (soundFile == nil){
        return;
    }
    
    //重置播放次数
    if (soundFile.playCount + 1 > 10000){
        soundFile.playCount = 0;
    }
    soundFile.playCount += 1;
    int playCount = soundFile.playCount;
    
    ALint sourceState;
    alGetSourcei(soundFile.sourceId, AL_SOURCE_STATE, & sourceState);
    if (sourceState == AL_PLAYING){
        alSourceStop(soundFile.sourceId);
    }
    
    //按力度计算
    int maxdB = 54;//声音对应力度差值，值越大力度差距导致的声音大小差距越大
    Float32 velocity = xMidiNoteMessage.velocity;
    if (velocity > 100){
        //防止音过高
        velocity = 100;
    }
    Float32 rate = velocity / 127.0f;
    int dB = maxdB * rate;
    Float32 vol = 1.0f / powf(2,(int)((maxdB - dB) / 6));
    if (vol > 1) vol = 1;
    alSourcef(soundFile.sourceId, AL_GAIN, vol);//设置音量大小，1.0f表示最大音量
    
    float sourcePos[] = { xMidiNoteMessage.panning, 0.0f, 0.0f };
    alSourcefv(soundFile.sourceId, AL_POSITION, sourcePos);

    //play
    alSourcePlay(soundFile.sourceId);
    
    //fadeOut
    Float32 duration = xMidiNoteMessage.duration;
    if (duration < 0){
        duration = 0;
    }
    double delayInSeconds = duration*0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //逐渐减小声音
        [self fadeOutWithSoundFile:soundFile
                playCount:playCount
            totalDuration:delayInSeconds
                totalStep:5
              currentStep:1
                 startVol:vol];
    });
    

    
    if (delegate != nil
        && [delegate respondsToSelector:@selector(playingSoundNote:)]) {
        [delegate playingSoundNote:xMidiNoteMessage];
    }
}

//
//  模拟声音逐渐变小效果
//
+(void)fadeOutWithSoundFile:(XSoundFile*)soundFile
                  playCount:(int)playCount
              totalDuration:(Float32)totalDuration
                  totalStep:(int)totalStep
                currentStep:(int)currentStep
                   startVol:(Float32)startVol
{
    if (isDisposed){
        return;
    }
    
    //播放计数不同时，说明音源被再次播放，音量已经被重置
    if (playCount != soundFile.playCount){
        return;
    }
    
    //逐渐减小声音
    alSourcef(soundFile.sourceId, AL_GAIN, startVol * (totalStep - currentStep) / totalStep);
    
    int step = currentStep + 1;
    double delayInSeconds = totalDuration > 0.2 ? totalDuration : 0.2 / totalStep;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fadeOutWithSoundFile:soundFile
                playCount:playCount
            totalDuration:totalDuration
                totalStep:totalStep
              currentStep:step
                 startVol:startVol];
    });
}
@end
