import SpriteKit

public class ScrollView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    /// SwiftySKScrollView direction
    public enum ScrollDirection {
        case vertical
        case horizontal
    }
    
    /// SwiftySKScrollView position
    public enum ScrollIndicatorPosition {
        case top
        case bottom
    }
    
    /// Disable status
    public var isDisabled = false {
        didSet {
            isUserInteractionEnabled = !isDisabled
        }
    }
    
    /// Moveable node
    private let moveableNode: SKNode
    
    /// Scroll direction
    private let direction: ScrollDirection
    
    /// Scroll indicator position
    private let indicatorPosition: ScrollIndicatorPosition
    
    /// Nodes touched. This will forward touches to node subclasses.
    private var touchedNodes = [AnyObject]()
    
    /// Current scene reference
    private weak var currentScene: SKScene?
    
    // MARK: - Init
    
    /// Init
    ///
    /// - parameter frame: The frame of the scroll view
    /// - parameter moveableNode: The moveable node that will contain all the sprites to be moved by the scrollview
    /// - parameter scrollDirection: The scroll direction of the scrollView.
    public init(frame: CGRect, moveableNode: SKNode, direction: ScrollDirection, indicatorPosition: ScrollIndicatorPosition = .bottom) {
        self.moveableNode = moveableNode
        self.direction = direction
        self.indicatorPosition = indicatorPosition
        super.init(frame: frame)
        
        if let scene = moveableNode.scene {
            self.currentScene = scene
        }

        backgroundColor = .clear
        self.frame = frame
        delegate = self
        indicatorStyle = .white
        isScrollEnabled = true
        
        // MARK: - Fix wrong indicator position in MenuScene
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        guard direction == .horizontal else { return }
        transform = CGAffineTransform(scaleX: -1, y: indicatorPosition == .bottom ? 1 : -1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
// MARK: - Touches
extension ScrollView {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesBegan(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
        
            currentScene.touchesBegan(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesBegan(touches, with: event)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesMoved(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
        
            currentScene.touchesMoved(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesMoved(touches, with: event)
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesEnded(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            currentScene.touchesEnded(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesEnded(touches, with: event)
            }
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesCancelled(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
        
            currentScene.touchesCancelled(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesCancelled(touches, with: event)
            }
        }
    }
}

// MARK: - Scroll View Delegate
extension ScrollView {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if direction == .horizontal {
            moveableNode.position.x = scrollView.contentOffset.x
        } else {
            moveableNode.position.y = scrollView.contentOffset.y
        }
    }
}
