//
//  GameScene.swift
//  XMidi
//
//  Created by Lugia on 15/3/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import SpriteKit

class XMidiFile {
    var fileName:String = ""
    
    init(fileName:String){
        self.fileName = fileName
    }
}

class XMidiTrackUnit{
    //频道ID
    var trackID:Int = 0
    //当前播放到哪里
    var playIndex:Int = 0
    //note事件
    var events:[XMidiEvent] = []
}

class XGameScene: SKScene {
    var lastUpdateTimeInterval:NSTimeInterval = NSTimeInterval()
    var midiFiles:[XMidiFile] = []
    
    //MIDI解析API
    var musicSequence:XMidiSequence!
    //Track数组，用于存储解析出来的Track
    var musicTracks:[XMidiTrackUnit] = []
    //播放时间轴
    var playTimeStamp:NSTimeInterval = 0
    
    var isPaused:Bool = false

    override func didMoveToView(view: SKView) {
        initMidiFiles()
        initUI()
    }
    
    func initMidiFiles(){
        midiFiles.append(XMidiFile(fileName:"Sonata No.9 in E-1"))
        midiFiles.append(XMidiFile(fileName:"Sonata No 14 in C#min-1"))
        midiFiles.append(XMidiFile(fileName:"Sonata No 14 in C#min-3"))
        midiFiles.append(XMidiFile(fileName:"Rondo in C (Op.51. No.1.)"))
        midiFiles.append(XMidiFile(fileName:"Rondeau"))
        midiFiles.append(XMidiFile(fileName:"至爱丽丝"))
        midiFiles.append(XMidiFile(fileName:"绮想轮旋曲"))
        midiFiles.append(XMidiFile(fileName:"埃克赛斯舞曲"))
        midiFiles.append(XMidiFile(fileName:"命运交响曲第一章"))
    }
    
    func initUI(){
        var w = self.size.width
        var h = self.size.height
        for i in 0..<midiFiles.count{
            var s = CGSize(width: w, height: h / CGFloat(midiFiles.count))
            var pos = CGPoint(x: w / 2, y: h - s.height * CGFloat(i) - s.height / 2)
            var button = XBarButton()
            button.initializer(pos, size: s)
            button.title = midiFiles[i].fileName
            button.xClick = {
                self.buttonClick(i)
            }
            self.addChild(button)
        }
    }
    
    func buttonClick(index:Int){
        var i = 0
        for n in 0..<self.children.count{
            if (self.children[n] is XBarButton){
                var btn = self.children[n] as XBarButton
                btn.titleColor = i == index ? UIColor.brownColor() : UIColor.whiteColor()
                i += 1
            }
        }
        self.playMidi(index)
    }
    
    func playMidi(index:Int){
        if (self.isPaused){
            return
        }
        
        self.isPaused = true
        var midi = midiFiles[index]
        
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
        self.isPaused = false
    }
    
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
}
