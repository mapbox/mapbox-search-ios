import UIKit

extension UIApplication {
    static var topPresentedViewController: UIViewController? {
        let keyWindow: UIWindow? = if #available(iOS 13, *) {
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        } else {
            UIApplication.shared.keyWindow
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
