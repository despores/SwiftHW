//
//  AppView.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit


final class AppView {
    private let coordinator: Coordinator
    
    public var viewController: UIViewController {
        coordinator.getViewController()
    }
    
    init() {
        coordinator = Coordinator()
    }
}
