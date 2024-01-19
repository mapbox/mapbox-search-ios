import MapboxSearch
import UIKit

protocol SendFeedbackControllerDelegate: AnyObject {
    func sendFeedbackDidReady()
    func sendFeedbackDidCancel()
    func sendFeedbackDidClose()
}

class SendFeedbackController: UIViewController {
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTitleLabel: UILabel!
    @IBOutlet private var submitButton: UIButton!

    weak var delegate: SendFeedbackControllerDelegate?

    var responseInfo: SearchResponseInfo?
    var feedbackReasons = FeedbackEvent.Reason.allCases.filter { $0 != .missingResult }
    var feedbackSuggestion: SearchSuggestion?
    var screenshot: UIImage?

    private lazy var selectedReason: FeedbackEvent.Reason = feedbackReasons[0]

    var configuration: Configuration {
        didSet {
            updateUI()
        }
    }

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: .mapboxSearchUI)
    }

    required init?(coder: NSCoder) {
        self.configuration = Configuration()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.cornerRadius = 8.0
        textView.accessibilityIdentifier = "FeedbackDescription"
        submitButton.setTitle(Strings.Feedback.submit, for: .normal)
        submitButton.accessibilityIdentifier = "FeedbackSubmitButton"
        titleLabel.text = Strings.Feedback.screenTitle
        descriptionTitleLabel.text = Strings.Feedback.descriptionTitle

        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self) // swiftlint:disable:this notification_center_detachment
    }

    func updateUI() {
        view.tintColor = configuration.style.primaryAccentColor
        view.backgroundColor = configuration.style.primaryBackgroundColor

        titleLabel.textColor = configuration.style.primaryTextColor
        descriptionTitleLabel.textColor = configuration.style.primaryTextColor
        textView.textColor = configuration.style.primaryTextColor
        textView.backgroundColor = configuration.style.secondaryBackgroundColor
    }

    @objc
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardFrame = view.convert(keyboardScreenFrame, from: view.window)

        let maxHeight: CGFloat = 200
        let minHeight: CGFloat = 30
        let submitButtonOffset: CGFloat = 70

        let textViewBottom = textView.frame.maxY + submitButtonOffset
        let overlapValue = textViewBottom - keyboardFrame.minY

        textViewHeightConstraint.constant = min(max(textView.frame.size.height - overlapValue, minHeight), maxHeight)

        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.beginFromCurrentState, .curveEaseOut]
        ) {
            self.view.layoutIfNeeded()
        }
    }

    func makeScreenshot(view: UIView) {
        let size = CGSize(width: 250, height: 250)
        let oldSize = view.bounds.size
        let scale = max(size.width / oldSize.width, size.height / oldSize.height)
        let newSize = CGSize(width: oldSize.width * scale, height: oldSize.height * scale)
        let newRect = CGRect(origin: .zero, size: newSize)
        let image = UIGraphicsImageRenderer(bounds: newRect).image { _ in
            view.drawHierarchy(in: newRect, afterScreenUpdates: true)
        }
        screenshot = image
    }

    func buildFeedbackEvent() -> FeedbackEvent? {
        let event: FeedbackEvent
        if let suggestion = feedbackSuggestion {
            event = FeedbackEvent(suggestion: suggestion, reason: selectedReason.rawValue, text: textView.text)
        } else if selectedReason == .missingResult, let response = responseInfo {
            event = FeedbackEvent(response: response, text: textView.text)
        } else {
            return nil
        }
        return event
    }

    func presentFeedbackError() {
        let alert = UIAlertController(
            title: Strings.Feedback.errorTitle,
            message: Strings.Feedback.errorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Strings.General.ok, style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func presentFeedbackConfirmation() {
        let alert = UIAlertController(
            title: Strings.Feedback.confirmTitle,
            message: Strings.Feedback.confirmMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Strings.General.ok, style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.delegate?.sendFeedbackDidReady()
        }))
        alert.addAction(UIAlertAction(title: Strings.General.cancel, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension SendFeedbackController {
    @IBAction
    func endEditingAction(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction
    func backAction(_ sender: Any) {
        delegate?.sendFeedbackDidCancel()
    }

    @IBAction
    func closeAction(_ sender: Any) {
        delegate?.sendFeedbackDidClose()
    }

    @IBAction
    func submitAction(_ sender: Any) {
        presentFeedbackConfirmation()
    }
}

extension SendFeedbackController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedReason = feedbackReasons[row]
    }
}

extension SendFeedbackController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        feedbackReasons.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        feedbackReasons[row].title
    }
}
