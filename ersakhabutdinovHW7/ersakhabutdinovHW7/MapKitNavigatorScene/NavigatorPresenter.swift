//
//  NavigatorPresenter.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit

protocol INavigatorPresenter {
    func set(view: NavigatorView, interactor: INavigatorInteractor)
    func goButtonWasPressed()
    func clearButtonWasPressed()
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
        guard let view = view else {
            return
        }
        view.changeTextAndButtonsState()
    }
    
}
