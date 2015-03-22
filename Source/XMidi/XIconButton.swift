import Foundation
import SpriteKit

class XIconButton:SKSpriteNode {
    enum xIconButtonTypes{
        case PauseIcon, PlayIcon

        func iconName() -> String{
            switch self{
            case .PauseIcon:
                return "PauseIcon"
            case .PlayIcon:
                return "PlayIcon"
            }
        }
    }
    
    var isEnabled = true
    
    private var _iconType:xIconButtonTypes = xIconButtonTypes.PlayIcon
    var iconType:xIconButtonTypes {
        get {
            return _iconType
        }
        set {
            _iconType = newValue
            var texture = SKTexture(imageNamed: _iconType.iconName())
            self.texture = texture
        }
    }
    
    typealias xClickEvent = () -> ()
    var xClick:xClickEvent?
    
    func initializer(postion:CGPoint,size:CGSize,iconType:xIconButtonTypes){
        self.userInteractionEnabled = true
        self.size = size
        self.position = postion
        self.iconType = iconType
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (!isEnabled){
            return
        }

        if (xClick != nil){
            self.xClick!()
        }
    }
}