import UIKit
import MapboxSearch
import Atlantis

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            ServiceProvider.shared.localFavoritesProvider.deleteAll()
            ServiceProvider.shared.localHistoryProvider.deleteAll()
            UserDefaults.resetStandardUserDefaults()
        }

        if let customEndpoint = ProcessInfo.processInfo.environment["search_endpoint"] {
            UserDefaults.standard.setValue(customEndpoint, forKey: "MGLMapboxAPIBaseURL")
        } else {
            UserDefaults.standard.setValue(nil, forKey: "MGLMapboxAPIBaseURL")
        }
        
        Atlantis.start()
        
        return true
    }
}
