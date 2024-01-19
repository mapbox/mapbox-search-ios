import UIKit

@IBDesignable
class PlaceholderView: UIView {
    override func awakeAfter(using coder: NSCoder) -> Any? {
        placeholdedView()
    }

    private func placeholdedView() -> UIView {
        guard let restorationIdentifier else {
            print("PlaceholderView: RestorationIdentifier is empty. Cannot instantiate an replacement")
            return self
        }

        let nibName = restorationIdentifier.trimmingCharacters(in: .decimalDigits)
        let nib = UINib(nibName: nibName, bundle: .mapboxSearchUI)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView else {
            print("PlaceholderView: First object in nib is not a UIView (nibName=\(nibName)")
            return self
        }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        view.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins

        return view
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        let nibView = placeholdedView()
        addSubview(nibView)
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
