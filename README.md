#XMIDI
###简介

>     XMIDI是一款IOS上的MIDI文件播放引擎，基于Audio Toolbox Framework和OpenAL这两个库。 	
>     XMIDI使用Audio Toolbox Framework下API来完成MIDI文件的读取和解析，然后使用OpenAL来播放对应的音符。
>     OpenAL播放声音时，对声音做了音量、立体声和渐隐处理，来模拟真实钢琴弹奏效果。
>     播放控制没有对制作应接口，主要是考虑大家可以自行控制播放。

###视频演示
[Demo 视频截这里](http://v.youku.com/v_show/id_XOTEzMTc0MTYw.html)

###API初始化方法
```javascript
    //初始化声音数据
    XOpenAL.initDevice()
    XSoundFile.initSoundData()
```

###音乐播放控制方法
> 	先要定义一个XMidiTrackUnit对象来存储Track和控制播放。

```javascript
 class XMidiTrackUnit{
        //频道ID
        var trackID:Int = 0
        //当前播放到哪里
        var playIndex:Int = 0
        //note事件
        var events:[XMidiEvent] = []
    }
```

> 定义需要的变量

```javascript
        //MIDI解析API
        var musicSequence:XMidiSequence!
        //Track数组，用于存储解析出来的Track
        var musicTracks:[XMidiTrackUnit] = []
        //播放时间轴
        var playTimeStamp:NSTimeInterval = 0
```
>读取并解析文件

```javascript
        //读取文件
        var filePath = NSBundle.mainBundle().pathForResource(midi.fileName, ofType: "mid")
        var url = NSURL(fileURLWithPath: filePath!)
        
        //清空Track数组
        self.musicTracks.removeAll(keepCapacity: false)
        
        //读取文件
        self.musicSequence = XMidiSequence(url!)
        
        //生成要播放的Track数组
        for index in 0..<self.musicSequence.tracks.count{
            var track = musicSequence.tracks[index] as XMidiTrack
            var trackUnit = XMidiTrackUnit()
            trackUnit.trackID = index

            for i in 0..<track.eventIterator.childEvents.count{
                var event = track.eventIterator.childEvents[i] as XMidiEvent;
                trackUnit.events.append(event)
            }
            self.musicTracks.append(trackUnit)
        }
        
        //初始化时间
        playTimeStamp = 0
```

>启动时间轴，播放音乐，这里需要注意需要计算bpm对时间轴速度的影响。updateGame方法控制在1/60秒执行一次即可。

```javascript
    //刷新事件
    override func update(currentTime: CFTimeInterval) {
        var timeSinceLast:CFTimeInterval = currentTime - self.lastUpdateTimeInterval
        self.lastUpdateTimeInterval = currentTime
        
        //注意，在代码中做了一些合理性的检查，以避免从上一帧更新到现在已经过去了大量时间，并且将间隔重置为1/60秒，避免出现奇怪的行为。
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0 / 60.0;
            self.lastUpdateTimeInterval = currentTime;
        }
        
        self.updateGame(timeSinceLast)
    }

    func updateGame(currentTime: CFTimeInterval) {
        if (!self.isPaused){
            //按bgm速率播放
            var bpm:Float32 = XMidiEvent.getTempoBpmInTimeStamp(Float32(playTimeStamp))
            playTimeStamp += NSTimeInterval(Float32(currentTime) / 60 * bpm)
            playSound()
            //防止益处
            if (playTimeStamp > 100000){
                playTimeStamp = 0
            }
        }
    }
    
    //播放声音
    func playSound(){
        if (self.musicSequence == nil) {return}
        if (self.musicSequence.tracks.count <= 0) {return}
        
        //循环小节
        for track in musicTracks{
            for index in track.playIndex..<(track.playIndex + 10){
                if (index < track.playIndex
                    || index >= track.events.count){
                    continue
                }
                
                var event = track.events[index]
                if (playTimeStamp >= NSTimeInterval(event.timeStamp) && !event.isPlayed){
                    track.playIndex = index
                    event.playEvent()
                }
            }
        }
    }
```
