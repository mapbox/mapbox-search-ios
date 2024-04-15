import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        let examplesRootController = ExamplesTableViewController()
        let navigationController = UINavigationController(rootViewController: examplesRootController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
