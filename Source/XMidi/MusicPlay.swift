//
//  GameScene.swift
//  XMidi
//
//  Created by Lugia on 15/3/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import SpriteKit

//XMidiPlayer播放示例
class MusicPlay: SKScene,XOpenALPlayerDelegate,XMidiPlayerDelegate{
    var backgroundLayout:SKSpriteNode!
    var uiLayout:SKSpriteNode!
    var buttons:[XBarButton] = []
    var midiFiles:[XMidiFile] = []
    
    var playButton:XIconButton!
    var progressBar:XProgressBar!
    
    var bgNode:SKSpriteNode!
    var isTouched:Bool = false
    var offsetX:Float32 = 0
    var offsetY:Float32 = 0
    
    //MIDI Player
    var midiPlayer:XMidiPlayer = XMidiPlayer()
    
    override func didMoveToView(view: SKView) {
        XOpenALPlayer.setDelegate(self)
        midiPlayer.delegate = self
        initMidiFiles()
        initLayout()
        initUI()
    }
    
    func initLayout(){
        backgroundLayout = SKSpriteNode()
        backgroundLayout.size = self.size
        backgroundLayout.position = CGPointZero
        backgroundLayout.anchorPoint = CGPointZero
        backgroundLayout.zPosition = 1
        self.addChild(backgroundLayout)

        uiLayout = SKSpriteNode()
        uiLayout.size = self.size
        uiLayout.position = CGPointZero
        uiLayout.anchorPoint = CGPointZero
        uiLayout.zPosition = 10
        uiLayout.color = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.62)
        self.addChild(uiLayout)
    }
    
    func initMidiFiles(){
        midiFiles.append(XMidiFile(fileName:"Sonata No 14 in C#min-1"))
        midiFiles.append(XMidiFile(fileName:"Sonata No 14 in C#min-3"))
        midiFiles.append(XMidiFile(fileName:"至爱丽丝"))
        midiFiles.append(XMidiFile(fileName:"绮想轮旋曲"))
        midiFiles.append(XMidiFile(fileName:"埃克赛斯舞曲"))
        midiFiles.append(XMidiFile(fileName:"命运交响曲第一章"))
    }
    
    func initUI(){
        var w = self.size.width
        var h = self.size.height
        
        //标题
        var titileLayout = SKSpriteNode()
        titileLayout.size = CGSize(width: w, height: 150)
        titileLayout.position = CGPoint(x: titileLayout.size.width / 2, y: h - titileLayout.size.height / 2)
        titileLayout.zPosition = 1
        uiLayout.addChild(titileLayout)

        var titleNode = SKLabelNode(fontNamed:"System")
        titleNode.text = "XMIDI"
        titleNode.fontSize = 60
        titleNode.fontColor = UIColor.whiteColor()
        titleNode.position = CGPoint(x:0, y: 0)
        titleNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        titileLayout.addChild(titleNode)
        
        //歌曲按钮
        var buttonsLayout = SKSpriteNode()
        buttonsLayout.size = CGSize(width: w, height: 300)
        buttonsLayout.position = CGPoint(x: 0, y: h - buttonsLayout.size.height - titileLayout.size.height)
        buttonsLayout.anchorPoint = CGPointZero
        buttonsLayout.zPosition = 1
        uiLayout.addChild(buttonsLayout)

        for i in 0..<midiFiles.count{
            var s = CGSize(width: w, height: 50)
            var pos = CGPoint(x: w / 2, y: buttonsLayout.size.height - s.height * CGFloat(i) - s.height / 2)
            var button = XBarButton()
            button.initializer(pos, size: s)
            button.title = midiFiles[i].fileName
            button.xClick = {
                self.buttonClick(i)
            }
            buttonsLayout.addChild(button)
            buttons.append(button)
        }
        
        //播放控制
        var playControlHeight:CGFloat = 60
        var playControlLayout = SKSpriteNode()
        playControlLayout.size = CGSize(width: w, height: playControlHeight)
        playControlLayout.position = CGPoint(x: 0, y: 0)
        playControlLayout.anchorPoint = CGPointZero
        playControlLayout.zPosition = 1
        uiLayout.addChild(playControlLayout)
        
        progressBar = XProgressBar()
        progressBar.initializer(CGPoint(x: playControlHeight, y: 0),
            size: CGSize(width: playControlLayout.size.width - playControlHeight * 1.3, height: playControlLayout.size.height))
        progressBar.anchorPoint = CGPointZero
        progressBar.xProgressChanged = {(progress:Double) -> () in
            self.midiPlayer.setProgress(progress)
        }
        playControlLayout.addChild(progressBar)
        
        playButton = XIconButton()
        playButton.initializer(CGPointZero,
            size:CGSize(width: playControlHeight, height: playControlHeight),
            iconType: XIconButton.xIconButtonTypes.PlayIcon)
        playButton.anchorPoint = CGPointZero
        playButton.xClick = {
            switch self.playButton.iconType{
            case .PlayIcon:
                self.midiPlayer.play()
                self.playButton.iconType = XIconButton.xIconButtonTypes.PauseIcon
            case .PauseIcon:
                self.midiPlayer.pause()
                self.playButton.iconType = XIconButton.xIconButtonTypes.PlayIcon
            }
        }
        playControlLayout.addChild(playButton)
        
        //特效
        var effectLayout = SKSpriteNode()
        effectLayout.size = CGSize(width: w, height: h)
        effectLayout.position = CGPoint(x: 0, y: 0)
        effectLayout.anchorPoint = CGPointZero
        effectLayout.zPosition = 0
        backgroundLayout.addChild(effectLayout)
        
        bgNode = SKSpriteNode()
        bgNode.size = effectLayout.size
        bgNode.color = UIColor.redColor()
        bgNode.position = CGPointZero
        bgNode.anchorPoint = CGPointZero
        effectLayout.addChild(bgNode)
        initBgShader(60)
    }
    
    func initBgShader(soundNote:Float32){
        bgNode.shader = XSharderCenter.getSound(Float32(self.size.width),
            nodeHeight: Float32(self.size.height),
            offsetX: offsetX,
            offsetY: offsetY,
            soundNote: soundNote)
    }
    
    func buttonClick(index:Int){
        var i = 0
        for n in 0..<buttons.count{
            var btn = buttons[n] as XBarButton
            btn.titleColor = i == index ? UIColor(red: 193/255, green: 209/255, blue: 105/255, alpha: 1) : UIColor.whiteColor()
            i += 1
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
        self.playButton.iconType = XIconButton.xIconButtonTypes.PauseIcon
    }
    
    func progressChanged(progress: Double) {
        progressBar.progress = progress
    }
    
    func playingSoundNote(xMidiNoteMessage: XMidiNoteMessage!) {
        initBgShader(Float32(xMidiNoteMessage.note))
    }
}
