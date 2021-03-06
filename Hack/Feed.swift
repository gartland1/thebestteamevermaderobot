
import Foundation
import UIKit


public class FeedOperation : NSOperation{
    
    enum State : String{
        case Ready, Executing, Finished
        private var keyPath : String{
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
}

extension FeedOperation {
    // NSOperation Overrides
    // NSOperation Overrides
    override public var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override public var executing: Bool {
        return state == .Executing
    }
    
    override public var finished: Bool {
        return state == .Finished
    }
    
    override public var asynchronous: Bool {
        return true
    }
    
    override public func start() {
        if cancelled {
            state = .Finished
            return
        }
        main()
        state = .Executing
    }
    
    override  public func cancel() {
        state = .Finished
    }
}


public class FeedQueueOperation : FeedOperation {
    
    private let address: String
    private let imageCallback: UIImage -> ()
    
    init(address: String, imageCallback: UIImage -> ()) {
        self.address = address
        self.imageCallback = imageCallback
    }
    
    override public func main() {
        self.state = .Executing
        let url = NSURL(string: "http://\(address):8080/frame.jpg")
        while(self.executing) {
            let imageData = NSData(contentsOfURL: url!)
            if let imgdata = imageData{
                if let image = UIImage(data: imgdata){
                    let filter = CIFilter(
                    image.CIImage.
                    imageCallback(image)
                }
            }
            
        }
    }
}

