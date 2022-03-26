import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        YMKMapKit.setApiKey("141822be-3861-47fb-a40f-5a02eb85f671")

        let graph = AppView()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = graph.viewController
        window?.makeKeyAndVisible()
        return true
    }

}

