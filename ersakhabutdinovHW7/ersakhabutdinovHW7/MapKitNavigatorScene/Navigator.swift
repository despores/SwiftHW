//
//  Navigator.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit

class Navigator {
    private let view: NavigatorView
    private let interactor: INavigatorInteractor
    private let presenter: INavigatorPresenter
    
    var viewController: UIViewController { view }
    
    init() {
        presenter = NavigatorPresenter()
        view = NavigatorView(presenter: presenter)
        interactor = NavigatorInteractor(view: view)
        presenter.set(view: view)
    }
}
