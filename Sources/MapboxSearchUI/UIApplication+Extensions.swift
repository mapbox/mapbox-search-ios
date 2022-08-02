// Copyright © 2022 Mapbox. All rights reserved.

import UIKit

extension UIApplication {
    static var topPresentedViewController: UIViewController? {
        let keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        } else {
            assertionFailure("Unexpected controller missing")
            
            return nil
        }
    }
}
