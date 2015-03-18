#XMIDI
###简介

>     XMIDI是一款IOS上的MIDI文件播放引擎，基于Audio Toolbox Framework和OpenAL这两个库。 	
>     XMIDI使用Audio Toolbox Framework下API来完成MIDI文件的读取和解析，然后使用OpenAL来播放对应的音符。
>     OpenAL播放声音时，对声音做了音量、立体声和渐隐处理，来模拟真实钢琴弹奏效果。
>     本引擎使用OC编写，项目示例为Swift语言。
>     使用上有问题可以联系我。
>     邮件:watarux@qq.com
>     QQ:56809958    
>     交流群:334533178

###视频演示
[Demo 视频截这里](http://v.youku.com/v_show/id_XOTEzMTc0MTYw.html)

###插播广告
>   给自己游戏做个宣传，欢迎大家下载
![AD](http://img1.ph.126.net/imgkyxAM-XEboVfJ_aTYZA==/649081296312690109.jpg)

###更新履历
####2015-03-18
>1.增加XMidiPlayer，现在播放MIDI文件更为方便。

####2015-03-17
>1.初次版本发布。

###使用方法
####1.初始化API
```javascript
    //初始化声音数据
    XOpenAL.initDevice()
    XSoundFile.initSoundData()
```

####2.播放MIDI文件
```javascript
    //读取文件
    var filePath = NSBundle.mainBundle().pathForResource("midiFileName", ofType: "mid")
    var url = NSURL(fileURLWithPath: filePath!)
        
    //MIDI Player
    var midiPlayer:XMidiPlayer = XMidiPlayer()
    midiPlayer.initMidi(url!)
    midiPlayer.play()
```
