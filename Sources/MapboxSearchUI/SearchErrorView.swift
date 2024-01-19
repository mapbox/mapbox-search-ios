import Foundation
import MapboxSearch
import UIKit

class SearchErrorView: UIView {
    enum ErrorType {
        case connectionError
        case genericError
        case serverError

        var title: String {
            switch self {
            case .connectionError:
                return Strings.SearchErrorView.noConnectionTitle
            case .genericError:
                return Strings.SearchErrorView.genericErrorTitle
            case .serverError:
                return Strings.SearchErrorView.serverErrorTitle
            }
        }

        var subTitle: String {
            switch self {
            case .connectionError:
                return Strings.SearchErrorView.noConnectionSubTitle
            case .genericError:
                return Strings.SearchErrorView.genericErrorSubTitle
            case .serverError:
                return Strings.SearchErrorView.serverErrorSubTitle
            }
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var retryButton: UIButton!

    var configuration: Configuration! {
        didSet {
            updateUI()
        }
    }

    var retryHandler = {}

    var type: ErrorType = .connectionError {
        didSet { applyType(type) }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

#if TARGET_INTERFACE_BUILDER
        configuration = .init()
#endif

        assert(configuration != nil)

        applyType(type)
        updateUI()

        retryButton.setTitle(Strings.SearchErrorView.tapToRetryTitle, for: .normal)
    }

    func updateUI() {
        backgroundColor = configuration.style.primaryBackgroundColor
        titleLabel.textColor = configuration.style.primaryInactiveElementColor
        subTitleLabel.textColor = configuration.style.primaryInactiveElementColor
        retryButton.backgroundColor = configuration.style.primaryAccentColor
    }

    func setError(_ error: SearchError) {
        switch error {
        case .generic(_, let domain, _):
            if domain == NSURLErrorDomain {
                type = .connectionError
            } else {
                type = .serverError
            }
        // .searchRequestFailed not necessary a server issue.
        // Consider adding new SearchErrorView.ErrorType case
        case .searchRequestFailed:
            type = .serverError
        default:
            type = .genericError
        }
    }

    private func applyType(_ type: ErrorType) {
        titleLabel.text = type.title
        subTitleLabel.text = type.subTitle
    }

    @IBAction
    func retryAction() {
        retryHandler()
    }
}
