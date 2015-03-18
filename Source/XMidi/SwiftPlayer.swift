//
//  GameScene.swift
//  XMidi
//
//  Created by Lugia on 15/3/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import SpriteKit

//自行控制播放示例
class SwiftPlayer: SKScene {
    var lastUpdateTimeInterval:NSTimeInterval = NSTimeInterval()
    var midiFiles:[XMidiFile] = []
    
    //MIDI解析API
    var midiSequence:XMidiSequence!
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
        
        //读取文件
        self.midiSequence = XMidiSequence(url!)
        
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
            //防止溢出
            if (playTimeStamp > 100000){
                playTimeStamp = 0
            }
        }
    }
    
    //播放声音
    func playSound(){
        if (self.midiSequence == nil) {return}
        if (self.midiSequence.tracks.count <= 0) {return}
        
        //循环小节
        for i in 0..<self.midiSequence.tracks.count{
            var track = self.midiSequence.tracks[i] as XMidiTrack
            var startIndex:Int = Int(track.playEventIndex)
            
            for index in startIndex..<(startIndex + 10){
                if (index < Int(track.playEventIndex)
                    || index >= track.eventIterator.childEvents.count){
                        continue
                }
                
                var event:XMidiEvent = track.eventIterator.childEvents[index] as XMidiEvent
                if (playTimeStamp >= NSTimeInterval(event.timeStamp) && !event.isPlayed){
                    track.playEventIndex = Int32(index)
                    event.playEvent()
                }
            }
        }
    }
}
