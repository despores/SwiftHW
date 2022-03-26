import UIKit

final class Coordinator {
    
    private func BuildNavigatorView() -> UIViewController {
        let navigator: Navigator = Navigator()
        return navigator.viewController
    }
    
    func getViewController() -> UIViewController {
        let view = BuildNavigatorView()
        return view
    }
}
