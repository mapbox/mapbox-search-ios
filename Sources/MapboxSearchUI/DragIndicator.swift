import UIKit

@IBDesignable
class DragIndicator: UIView {
    var configuration: Configuration? {
        didSet {
            updateUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateUI()
    }

    func updateUI() {
        backgroundColor = configuration?.style.panelHandlerColor ?? Colors.panelHandler
        layer.cornerRadius = 1.5
    }

    override var intrinsicContentSize: CGSize {
        return .init(width: 45, height: 4)
    }
}
