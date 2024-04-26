import MapboxSearch
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            ServiceProvider.shared.localFavoritesProvider.deleteAll()
            ServiceProvider.shared.localHistoryProvider.deleteAll()
        }

        setUpProgrammaticUI(application: application)

        return true
    }

    /// Set up the fifth tab 'Offline' programmatically.
    private func setUpProgrammaticUI(application: UIApplication) {
        let tabBarControllers = application.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .compactMap { window in
                window.backgroundColor = UIColor.systemBackground
                return window.rootViewController as? UITabBarController
            }

        let offlineDemoViewController = OfflineDemoViewController()
        offlineDemoViewController.tabBarItem = UITabBarItem(
            title: "Offline",
            image: UIImage(systemName: "icloud.and.arrow.down"),
            tag: 0
        )

        for tabBarController in tabBarControllers {
            guard var viewControllers = tabBarController.viewControllers else {
                break
            }
            viewControllers.append(offlineDemoViewController)
            tabBarController.setViewControllers(viewControllers, animated: false)
        }
    }
}
