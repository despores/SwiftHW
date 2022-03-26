import UIKit


final class AppView {
    
    public var viewController: UIViewController {
        let navigator = Navigator()
        return navigator.viewController
    }
    
}
