import Foundation
import SpriteKit

class XProgressBar:SKSpriteNode {
    private var _progress:Double = 0
    var progress:Double {
        get{
            return _progress
        }
        set{
            //在调整进度
            if (isTouched){
                return
            }
            _progress = newValue
            if (_progress < 0){
                _progress = 0
            }
            if (_progress > 1){
                _progress = 1
            }
            buttonNode.position.x = (self.size.width - self.buttonNode.size.width) * CGFloat(_progress)
            fontBarNode.size.width = (self.size.width - buttonNode.size.width) * CGFloat(_progress)
        }
    }
    
    typealias xProgressChangedEvent = (progress:Double) -> ()
    var xProgressChanged:xProgressChangedEvent?
    
    private var backBarNode:SKSpriteNode!
    private var fontBarNode:SKSpriteNode!
    private var buttonNode:SKSpriteNode!
    
    var isTouched:Bool = false
    
    func initializer(postion:CGPoint,size:CGSize){
        self.userInteractionEnabled = true
        self.size = size
        self.position = postion
        
        initUI()
    }
    
    private func initUI(){
        buttonNode = SKSpriteNode()
        buttonNode.texture = SKTexture(imageNamed: "CircleIcon")
        buttonNode.size = CGSize(width: 25, height: 25)
        buttonNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        buttonNode.position = CGPoint(x: 0, y: self.size.height / 2)
        buttonNode.zPosition = 1
        self.addChild(buttonNode)
        
        backBarNode = SKSpriteNode()
        backBarNode.color = UIColor(red: 193/255, green: 209/255, blue: 105/255, alpha: 1)
        backBarNode.size = CGSize(width: self.size.width - buttonNode.size.width, height: 3)
        backBarNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        backBarNode.position = CGPoint(x: buttonNode.size.width / 2, y: self.size.height / 2)
        backBarNode.zPosition = 0
        self.addChild(backBarNode)
        
        fontBarNode = SKSpriteNode()
        fontBarNode.color = UIColor.whiteColor()
        fontBarNode.size = CGSize(width: 0, height: 3)
        fontBarNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        fontBarNode.position = CGPoint(x: buttonNode.size.width / 2, y: self.size.height / 2)
        fontBarNode.zPosition = 0
        self.addChild(fontBarNode)
    }

    private func moveButtonNode(moveVal:CGVector){
        var pos = self.position
        var x = buttonNode.position.x - moveVal.dx
        if (x < 0){
            x = 0
        }
        if (x > self.size.width - self.buttonNode.size.width){
            x = self.size.width - self.buttonNode.size.width
        }
        self._progress = Double(x / (self.size.width - self.buttonNode.size.width))
        buttonNode.position.x = (self.size.width - self.buttonNode.size.width) * CGFloat(_progress)
        fontBarNode.size.width = (self.size.width - buttonNode.size.width) * CGFloat(_progress)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (!isTouched){
            for touch in touches{
                isTouched = true
                break
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (isTouched){
            for touch in (touches as! Set<UITouch>){
                var prevPos = touch.previousLocationInNode(self)
                var pos = touch.locationInNode(self)
                var dx = prevPos.x - pos.x
                var dy = prevPos.y - pos.y
                moveButtonNode(CGVector(dx: dx, dy: dy))
                break
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (xProgressChanged != nil){
            self.xProgressChanged!(progress: self._progress)
        }
        isTouched = false
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        isTouched = false
    }
}