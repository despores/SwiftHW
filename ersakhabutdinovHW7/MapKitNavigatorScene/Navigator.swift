import UIKit

class Navigator {
    private let view: NavigatorView
    private let interactor: INavigatorInteractor
    private let presenter: INavigatorPresenter
    
    var viewController: UIViewController { view }
    
    init() {
        presenter = NavigatorPresenter()
        view = NavigatorView(presenter: presenter)
        interactor = NavigatorInteractor(presenter: presenter)
        presenter.set(view: view, interactor: interactor)
    }
}
