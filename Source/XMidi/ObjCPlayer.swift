//
//  GameScene.swift
//  XMidi
//
//  Created by Lugia on 15/3/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import SpriteKit

//XMidiPlayer播放示例
class ObjCPlayer: SKScene {
    var midiFiles:[XMidiFile] = []
    
    //MIDI Player
    var midiPlayer:XMidiPlayer = XMidiPlayer()
    
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
        var midi = midiFiles[index]
        
        //读取文件
        var filePath = NSBundle.mainBundle().pathForResource(midi.fileName, ofType: "mid")
        var url = NSURL(fileURLWithPath: filePath!)
        
        midiPlayer.initMidi(url!)
        midiPlayer.play()
    }
}
