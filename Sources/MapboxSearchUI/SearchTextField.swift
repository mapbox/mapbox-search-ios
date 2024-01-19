import UIKit

protocol SearchTextFieldDelegate: AnyObject {
    func searchTextFieldBeginEditing(_ textfield: SearchTextField)
    func searchTextFieldEndEditing(_ textfield: SearchTextField)
    func searchTextFieldTextDidChanged(query: String?, _ textField: SearchTextField)
}

class SearchTextField: UIView {
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var textField: UITextField!

    weak var delegate: SearchTextFieldDelegate?

    var customPlaceholder: String? {
        didSet {
            if configuration != nil {
                updateUI()
            }
        }
    }

    var configuration: Configuration! {
        didSet {
            updateUI()
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

#if TARGET_INTERFACE_BUILDER
        configuration = .init()
#endif

        assert(configuration != nil)

        updateUI()
    }

    func updateUI() {
        backgroundColor = configuration.style.secondaryBackgroundColor
        iconView.tintColor = configuration.style.primaryInactiveElementColor
        textField.textColor = configuration.style.primaryTextColor
        textField.font = Fonts.default(style: .subheadline, traits: traitCollection)
        textField.adjustsFontForContentSizeCategory = true
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true

        let text = customPlaceholder ?? Strings.SearchTextField.placeholder
        let attributes = [NSAttributedString.Key.foregroundColor: configuration.style.primaryInactiveElementColor]
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superHitTest = super.hitTest(point, with: event)
        return superHitTest === self ? textField : superHitTest
    }

    func updateQuery(_ query: String?) {
        textField.text = query
        delegate?.searchTextFieldTextDidChanged(query: query, self)
    }

    func eraseText() {
        textField.text = nil
    }

    @IBAction
    func textFieldTextDidChanged() {
        delegate?.searchTextFieldTextDidChanged(query: textField.text, self)
    }

    func startEditing() {
        textField.becomeFirstResponder()
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchTextFieldBeginEditing(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.searchTextFieldEndEditing(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
