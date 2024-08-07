import Foundation
import UIKit

/// Controller with floating behavior. Designed for `MapboxSearchController` purposes.
public class MapboxPanelController: UIViewController {
    /// State of `MapboxPanelController`
    public enum State {
        /// Panel is opened on full height
        case opened

        /// Panel is collapsed. Only search bar and few category buttons (configurable) would be visible.
        case collapsed

        /// Panel is totally hidden.
        case hidden
    }

    /// Configuration for `MapboxPanelController` class. Use `.default` for default cases
    public struct PanelConfiguration {
        var topOffset: CGFloat = 40

        lazy var topDraggingWall = topOffset

        var bottomOffset: CGFloat = 172

        let maximumPanelWidth: CGFloat = 382

        /// Initial appearance state of the panel.
        public var initialState: State

        /// Configuration with set of default values.
        public static let `default` = PanelConfiguration()

        /// Make new `Configuration` instance for `MapboxPanelController`
        /// - Parameter state: Initial state of `MapboxPanelController`
        public init(state: State? = nil) {
            if let state {
                self.initialState = state
            } else {
                self.initialState = UIDevice.current.userInterfaceIdiom == .pad ? .opened : .collapsed
            }
        }
    }

    var configuration: PanelConfiguration

    /// Damping ration animation parameter
    public var dampingRatio: CGFloat = 0.7

    /// Animation duration to be used on dragging end phase animation
    public var animationDuration: TimeInterval = 0.35

    /// State of panel. To change value, use `setState(_:animated:)`
    public private(set) var state: State

    /// Change panel state. Animatable
    /// - Parameters:
    ///   - toState: New state
    ///   - animated: Animate state change
    public func setState(_ toState: State, animated: Bool = true) {
        setState(toState, forced: false, animated: animated)
    }

    /// Update top constraint based on`toState` value.
    /// - Parameters:
    ///   - toState: New state value
    ///   - forced: Do not check current state value before update
    ///   - animated: Animate changes
    func setState(_ toState: State, forced: Bool = false, animated: Bool = true) {
        if !forced {
            guard toState != state else { return }
        }

        let topConstant: CGFloat = switch toState {
        case .opened:
            configuration.topOffset
        case .collapsed:
            bottomConstantFromTopEdge
        case .hidden:
            view.superview?.bounds.height ?? UIScreen.main.bounds.height
        }
        topConstraint?.constant = topConstant
        state = toState

        if animated {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: 0, options: [
                .beginFromCurrentState,
                .allowUserInteraction,
            ], animations: {
                self.view.superview?.layoutIfNeeded()
            })
        }
    }

    let panelNavigationController: UINavigationController

    /// Optional `MapboxSearchController` configuration.
    ///
    /// Would be `nil` if no `MapboxSearchController` would found.
    var searchConfiguration: MapboxSearchUI.Configuration? {
        let searchController = panelNavigationController.viewControllers.first as? MapboxSearchController
        return searchController?.configuration
    }

    /// Make new `MapboxPanelController` with custom `PanelConfiguration`
    /// - Parameters:
    ///   - rootViewController: Root controller to be embedded into MapboxPanelController
    ///   - configuration: PanelConfiguration for MapboxPanelController. Defaults to `.default`
    public init(rootViewController: UIViewController, configuration: PanelConfiguration = .default) {
        self.panelNavigationController = UINavigationController(rootViewController: rootViewController)
        panelNavigationController.isNavigationBarHidden = true
        self.configuration = configuration
        self.state = configuration.initialState
        super.init(nibName: nil, bundle: nil)

        addChild(panelNavigationController)
    }

    required init?(coder: NSCoder) {
        self.configuration = .default
        self.panelNavigationController = UINavigationController()
        self.state = configuration.initialState
        super.init(coder: coder)

        guard !children.isEmpty else { fatalError("\(MapboxPanelController.self) requires child controller") }

        panelNavigationController.setViewControllers([children[0]], animated: false)

        addChild(panelNavigationController)
    }

    private var topConstraint: NSLayoutConstraint?

    /// The value of `topConstraint` constant on `.begin` pan gesture
    private var initialDraggingTopConstraint: CGFloat?

    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

    private lazy var dragIndicator = DragIndicator()

    /// Make panel from the ground without XIB support.
    override public func loadView() {
        view = UIView()

        updateUI(for: searchConfiguration)

        view.clipsToBounds = false
        view.layer.cornerRadius = 7
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset.height = 1
        view.preservesSuperviewLayoutMargins = false
        view.insetsLayoutMarginsFromSafeArea = false
        view.directionalLayoutMargins.top = 22

        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self

        view.addSubview(dragIndicator)
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dragIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ])

        view.addSubview(panelNavigationController.view)
    }

    /// Separate method to update shadow color
    /// This methods is needed to be called on each traitCollection change
    /// because we use CGColor that doesn't support DynamicProvider's as a color value
    func updateShadowColor() {
        view.layer.shadowColor = searchConfiguration?.style.panelShadowColor.cgColor ?? Colors.panelShadow.cgColor
    }

    func updateUI(for configuration: MapboxSearchUI.Configuration?) {
        view.backgroundColor = searchConfiguration?.style.primaryBackgroundColor ?? Colors.background
        dragIndicator.configuration = searchConfiguration
        updateShadowColor()
    }

    /// Update shadows on trait updates.
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateShadowColor()
    }

    /// Recalculate shadows and layout margins.
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.directionalLayoutMargins.bottom = configuration.topOffset + view.safeAreaInsets.top

        // No force state change if drag gesture is in progress.
        // Otherwise setState() will interrupt gesture and panel will stuck
        setState(state, forced: panGestureRecognizer.numberOfTouches == 0, animated: false)
    }

    /// Simplify presentation with automatic adding subview to the parent view.
    override public func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if let parent {
            parent.view.addSubview(view)
            addPresentationConstraints(presentationView: parent.view)
        } else {
            view.removeFromSuperview()
        }
    }

    /// Horizontal alignment enum
    public enum HorizontalAlignment {
        /// Align panel along leading edge.
        case leading

        /// Align panel to be centered.
        case center

        /// Align panel along trailing edge.
        case trailing
    }

    /// Horizontal alignment for `MapboxPanelController`. Updates are animated by default
    ///
    /// Defaults to `.leading` on iPads and `.center` on the others
    public var horizontalAlignment: HorizontalAlignment = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .leading
        } else {
            return .center
        }
    }() {
        didSet {
            updateHorizontalAlignmentConstraints(animated: true)
        }
    }

    var leadingAlignmentConstraint: NSLayoutConstraint!
    var centerAlignmentConstraint: NSLayoutConstraint!
    var trailingAlignmentConstraint: NSLayoutConstraint!

    private func addPresentationConstraints(presentationView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        var presentationConstraints = [
            view.leadingAnchor.constraint(lessThanOrEqualTo: presentationView.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(greaterThanOrEqualTo: presentationView.layoutMarginsGuide.trailingAnchor),
            view.heightAnchor.constraint(
                greaterThanOrEqualTo: presentationView.layoutMarginsGuide.heightAnchor,
                constant: -configuration.topOffset
            ),
        ]
        presentationConstraints.forEach { $0.priority = .defaultHigh }

        let widthLimitConstraint = view.widthAnchor.constraint(
            lessThanOrEqualToConstant:
            configuration.maximumPanelWidth
        )
        presentationConstraints.append(widthLimitConstraint)

        let bottomConstraint = view.bottomAnchor.constraint(equalTo: presentationView.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        presentationConstraints.append(bottomConstraint)

        let topConstraint = view.topAnchor.constraint(equalTo: presentationView.safeAreaLayoutGuide.topAnchor)
        switch configuration.initialState {
        case .collapsed:
            topConstraint.constant = bottomConstantFromTopEdge
        case .opened:
            topConstraint.constant = configuration.topOffset
        case .hidden:
            topConstraint.constant = view.superview?.bounds.height ?? UIScreen.main.bounds.height
        }
        topConstraint.priority = .defaultHigh
        presentationConstraints.append(topConstraint)
        self.topConstraint = topConstraint

        panelNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        let embeddedNavigationConstraints = [
            panelNavigationController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            panelNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panelNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panelNavigationController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]

        NSLayoutConstraint.activate(presentationConstraints + embeddedNavigationConstraints)

        // Setup alignment constraints
        leadingAlignmentConstraint = view.leadingAnchor
            .constraint(equalTo: presentationView.layoutMarginsGuide.leadingAnchor)
        centerAlignmentConstraint = view.centerXAnchor
            .constraint(equalTo: presentationView.centerXAnchor)
        trailingAlignmentConstraint = view.trailingAnchor
            .constraint(equalTo: presentationView.layoutMarginsGuide.trailingAnchor)

        updateHorizontalAlignmentConstraints()
    }

    func updateHorizontalAlignmentConstraints(animated: Bool = false) {
        var (leading, center, trailing) = (false, false, false)

        switch horizontalAlignment {
        case .leading:
            leading = true
        case .center:
            center = true
        case .trailing:
            trailing = true
        }

        leadingAlignmentConstraint?.isActive = leading
        centerAlignmentConstraint?.isActive = center
        trailingAlignmentConstraint?.isActive = trailing

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.view.superview?.layoutIfNeeded()
            }
        }
    }

    private var bottomConstantFromTopEdge: CGFloat {
        view.superview.map { $0.bounds.height - configuration.bottomOffset - $0.safeAreaInsets.top } ?? 0
    }

    /// UIScrollView resistance constant
    ///
    /// Consumed in deceleration algo on pan gesture ending animation
    /// - Author:  https://gist.github.com/originell/6961057
    private let decelerationResistance: CGFloat = 0.55

    @IBAction
    private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let topConstraint else {
            assertionFailure("Dragging started without self.topConstraint be set")
            return
        }
        if gestureRecognizer.state == .began {
            view.endEditing(true)
            initialDraggingTopConstraint = topConstraint.constant
        }

        let translation = gestureRecognizer.translation(in: view)
        let nextTopConstant = initialDraggingTopConstraint! + translation.y
        topConstraint.constant = max(configuration.topDraggingWall, nextTopConstant)

        guard gestureRecognizer.state == .ended else { return }

        finishDragging(gestureRecognizer, topConstraintConstant: topConstraint.constant)
    }

    private func finishDragging(_ gestureRecognizer: UIPanGestureRecognizer, topConstraintConstant: CGFloat) {
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
        let decelerationLength = velocity.y * decelerationResistance
        let finalDecelerationPoint = topConstraintConstant + decelerationLength

        let limitedFinalConstant: CGFloat
        if abs(finalDecelerationPoint - configuration.topOffset)
            <= abs(finalDecelerationPoint - bottomConstantFromTopEdge)
        {
            limitedFinalConstant = configuration.topOffset
            state = .opened
        } else {
            limitedFinalConstant = bottomConstantFromTopEdge
            state = .collapsed
        }

        let actualDecelerationLength = abs(limitedFinalConstant - topConstraintConstant)
        guard !actualDecelerationLength.isZero else { return }

        let springInitialVelocity = abs(velocity.y / actualDecelerationLength)
        let unitVector = CGVector(dx: 0, dy: springInitialVelocity)
        let timingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: unitVector)

        let animator = UIViewPropertyAnimator(duration: animationDuration, timingParameters: timingParameters)
        animator.addAnimations {
            self.topConstraint?.constant = limitedFinalConstant
            self.view.superview?.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    func push(viewController: UIViewController, animated: Bool) {
        panelNavigationController.pushViewController(viewController, animated: animated)
    }

    @discardableResult
    func pop(animated: Bool) -> UIViewController? {
        panelNavigationController.popViewController(animated: animated)
    }
}

extension MapboxPanelController: UIGestureRecognizerDelegate {
    /// Disable vertical UIPanGestureRecognizer to fail on horizontal gestures.
    /// This is required for others horizontal gesture recognizers like UITableViewCell leading/trailing swipe actions
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
              gestureRecognizer == panGestureRecognizer
        else {
            return true
        }
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
        return abs(velocity.y) > abs(velocity.x)
    }
}

extension UIViewController {
    var mapboxPanelController: MapboxPanelController? {
        sequence(first: self, next: ({ $0.parent }))
            .lazy
            .compactMap { $0 as? MapboxPanelController }
            .first(where: { _ in return true })
    }
}
