import MapboxSearch
import UIKit

protocol SearchBarDelegate: AnyObject {
    func searchTextFieldBeginEditing()
    func searchQueryDidChanged(_ newQuery: String?)
    func searchTextFieldEndEditing()
    func cancelSearch()
}

extension SearchBarDelegate {
    func searchTextFieldEndEditing() {}
}

class SearchBar: UIView {
    weak var delegate: SearchBarDelegate?

    var customSearchBarPlaceholder: String? {
        didSet {
            searchTextField.customPlaceholder = customSearchBarPlaceholder
        }
    }

    @IBOutlet private var searchTextField: SearchTextField!
    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var textFieldDefaultTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var textFieldInSearchTrailingConstraint: NSLayoutConstraint!

    var configuration: Configuration! {
        didSet {
            searchTextField?.configuration = configuration
            cancelButton.tintColor = configuration.style.primaryAccentColor
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

#if TARGET_INTERFACE_BUILDER
        configuration = .init()
#endif

        assert(configuration != nil)

        searchTextField.delegate = self
        cancelButton.accessibilityIdentifier = "CancelButton"
        cancelButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }

    func cancelSearch(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.25 : 0, delay: 0, options: [
            .beginFromCurrentState,
            .allowUserInteraction,
        ], animations: {
            self.textFieldInSearchTrailingConstraint.isActive = false
            self.textFieldDefaultTrailingConstraint.isActive = true
            self.cancelButton.alpha = 0
            self.layoutIfNeeded()
        })

        searchTextField.eraseText()
        endEditing(true)
    }

    @IBAction
    func cancelSearchButtonTap() {
        cancelSearch()
        delegate?.cancelSearch()
    }

    func updateQueryUI(_ newQuery: String?, notifyDelegate: Bool = true) {
        searchTextField.updateQuery(newQuery)
    }

    func startEditing() {
        searchTextField.startEditing()
    }
}

extension SearchBar: SearchTextFieldDelegate {
    func searchTextFieldBeginEditing(_ textfield: SearchTextField) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.textFieldDefaultTrailingConstraint.isActive = false
                self.textFieldInSearchTrailingConstraint.isActive = true
                self.cancelButton.alpha = 1.0
                self.layoutIfNeeded()
            }
        )

        delegate?.searchTextFieldBeginEditing()
    }

    func searchTextFieldEndEditing(_ textfield: SearchTextField) {
        delegate?.searchTextFieldEndEditing()
    }

    func searchTextFieldTextDidChanged(query: String?, _ textField: SearchTextField) {
        delegate?.searchQueryDidChanged(query)
    }
}

extension SearchBar: SearchSuggestionCellDelegate {
    func populate(searchSuggestion: SearchSuggestion) {
        searchTextField.updateQuery(searchSuggestion.name)
    }
}
