import Atlantis
import MapboxSearch
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Atlantis.start(hostName: "")

        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            ServiceProvider.shared.localFavoritesProvider.deleteAll()
            ServiceProvider.shared.localHistoryProvider.deleteAll()
        }

        return true
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        window?.backgroundColor = UIColor.systemBackground
        if let tabBarController = window?.rootViewController as? UITabBarController {
            setUpProgrammaticUI(tabBarController: tabBarController)
        }
    }

    /// Set up the fifth tab 'Offline' programmatically.
    private func setUpProgrammaticUI(tabBarController: UITabBarController) {
        guard var viewControllers = tabBarController.viewControllers else {
            return
        }

        let offlineDemoViewController = OfflineDemoViewController()
        offlineDemoViewController.tabBarItem = UITabBarItem(
            title: "Offline",
            image: UIImage(systemName: "icloud.and.arrow.down"),
            tag: 0
        )

        viewControllers.append(offlineDemoViewController)
        viewControllers.append(contentsOf: ExamplesListing().allExamples())

        tabBarController.setViewControllers(viewControllers, animated: false)
    }
}
