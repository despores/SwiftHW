//
//  AppDelegate.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let graph = AppView()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = graph.viewController
        window?.makeKeyAndVisible()
        return true
    }

}

