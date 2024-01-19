import UIKit

class NoSuggestionsView: UIView {
    let labelOffset: CGFloat = 20

    @IBOutlet private var label: UILabel!
    @IBOutlet private var missingResultButton: UIButton!
    @IBOutlet private var suggestionLabelTopConstraint: NSLayoutConstraint!

    var missingResultHandler: (() -> Void)?

    @IBAction
    private func missingResultAction() {
        missingResultHandler?()
    }

    var suggestionLabelVisible = true {
        didSet {
            setLabelVisible(suggestionLabelVisible)
        }
    }

    func setLabelVisible(_ visible: Bool, animated: Bool = false) {
        let offset = visible ? labelOffset : -label.bounds.height
        let duration: TimeInterval = animated ? 0.2 : 0
        suggestionLabelTopConstraint.constant = offset

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    func configure(configuration: Configuration) {
        backgroundColor = configuration.style.primaryBackgroundColor
        label.textColor = configuration.style.primaryInactiveElementColor

        missingResultButton.tintColor = configuration.style.primaryAccentColor

        label.text = Strings.SearchErrorView.noSuggestionsTitle
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.bold(style: .footnote, traits: traitCollection)
    }
}
