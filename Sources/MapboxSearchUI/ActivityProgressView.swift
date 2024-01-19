import UIKit

class ActivityProgressView: UIView {
    @IBOutlet var activityIndicator: UIActivityIndicatorView! // swiftlint:disable:this private_outlet

    var configuration: Configuration! {
        didSet {
            backgroundColor = configuration.style.primaryBackgroundColor
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

#if TARGET_INTERFACE_BUILDER
        configuration = .init()
#endif

        assert(configuration != nil)

        if newWindow != nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SwiftLeeViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

@available(iOS 13.0, *)
struct SwiftLeeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SwiftLeeViewRepresentable()
    }
}
#endif
