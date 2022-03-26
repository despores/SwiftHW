import UIKit

protocol INavigatorPresenter {
    func set(view: NavigatorView, interactor: INavigatorInteractor)
    func goButtonWasPressed()
    func clearButtonWasPressed()
    func zoomButtonWasPressed(zoom: Float)
}

class NavigatorPresenter: INavigatorPresenter {
    
    weak var view: NavigatorView?
    var interactor: INavigatorInteractor?
    
    func set(view: NavigatorView, interactor: INavigatorInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func goButtonWasPressed() {
        guard let interactor = interactor else {
            return
        }

        interactor.pathQuery(view: view!)
    }
    
    func clearButtonWasPressed() {
        guard
            let view = view,
            let interactor = interactor else {
            return
        }
        interactor.clearMap(view: view)
        view.changeTextAndButtonsState()
    }
    
    func zoomButtonWasPressed(zoom: Float) {
        guard let view = view else {
            return
        }
        view.changeZoom(zoom: zoom)
    }
    
}
