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

        return true
    }
}
