import UIKit
import MapboxSearch
import Atlantis

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var addressAutofill: AddressAutofill?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            ServiceProvider.shared.localFavoritesProvider.deleteAll()
            ServiceProvider.shared.localHistoryProvider.deleteAll()
            UserDefaults.resetStandardUserDefaults()
        }
        
        UserDefaults.standard.setValue(true, forKey: "com.mapbox.mapboxsearch.enableSBS")
        
        if let customEndpoint = ProcessInfo.processInfo.environment["search_endpoint"] {
            UserDefaults.standard.setValue(customEndpoint, forKey: "MGLMapboxAPIBaseURL")
        } else {
            UserDefaults.standard.setValue(nil, forKey: "MGLMapboxAPIBaseURL")
        }
        
        Atlantis.start()

        return true
    }
}
