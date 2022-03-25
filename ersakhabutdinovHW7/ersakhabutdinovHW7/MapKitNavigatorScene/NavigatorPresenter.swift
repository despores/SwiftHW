//
//  NavigatorPresenter.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit

protocol INavigatorPresenter {
    func set(view: NavigatorView)
    func goButtonWasPressed()
    func clearButtonWasPressed()
}

class NavigatorPresenter: INavigatorPresenter {
    
    weak var view: NavigatorView?
    
    func set(view: NavigatorView) {
        self.view = view
    }
    
    @objc
    func goButtonWasPressed() {
        
    }
    
    func clearButtonWasPressed() {
        guard let view = view else {
            return
        }
        view.changeTextAndButtonsState()
    }
    
}
