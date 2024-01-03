import UIKit

class CategoriesFavoritesSegmentControl: UIControl {
    enum Tab {
        case categories
        case favorites
    }
    
    var selectedTab: Tab = .categories
    
    var selectionSegmentProgress: CGFloat = 0 {
        didSet {
            let screenScale = (window?.screen ?? .main).scale
            let maxSelectionOffsetX = self.bounds.width - self.selectionSegment.bounds.width
            let offsetX = round(maxSelectionOffsetX * self.selectionSegmentProgress * screenScale) / screenScale
            
            self.selectionSegment.frame.origin.x = offsetX
            
            let forceExplicitAnimations = CATransaction.value(forKey: self.forceExplicitAnimationTransactionKey) as? Bool == true
            
            CATransaction.begin()
            if forceExplicitAnimations {
                CATransaction.setAnimationDuration(0.25)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            } else {
                CATransaction.setDisableActions(true)
            }
            
            self.updateMasksOffsets()
            
            CATransaction.commit()
        }
    }
    
    @IBOutlet private var categoriesTitle: UIButton!
    @IBOutlet private var categoriesInactiveTitle: UIButton!
    
    @IBOutlet private var favoritesTitle: UIButton!
    @IBOutlet private var favoritesInactiveTitle: UIButton!
    
    @IBOutlet private var selectionSegment: UIView!
    @IBOutlet private var selectionCategoriesHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet private var selectionFavoritesHorizontalConstraint: NSLayoutConstraint!
    
    var configuration: Configuration! {
        didSet {
            updateUI()
        }
    }
    
    /// Internal key to point that we would like to don't disable CALayer's explicit animations
    private let forceExplicitAnimationTransactionKey = "com.mapbox.search.forceExplicitAnimations"
    
    let categoriesTitleMask = CALayer()
    let categoriesInactiveTitleMask = CAShapeLayer()
    
    let favoritesTitleMask = CALayer()
    let favoritesInactiveTitleMask = CAShapeLayer()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        #if TARGET_INTERFACE_BUILDER
        configuration = .init()
        #endif
        
        assert(configuration != nil)
        
        categoriesTitle.titleLabel?.font = Fonts.bold(style: .caption2, traits: traitCollection)
        categoriesTitle.setTitle(Strings.CategoriesFavoritesSegmentControl.categories,
                                 for: .normal)
        
        categoriesInactiveTitle.titleLabel?.font = Fonts.bold(style: .caption2, traits: traitCollection)
        categoriesInactiveTitle.setTitle(Strings.CategoriesFavoritesSegmentControl.categories,
                                         for: .normal)
        
        favoritesTitle.titleLabel?.font = Fonts.bold(style: .caption2, traits: traitCollection)
        favoritesTitle.setTitle(Strings.CategoriesFavoritesSegmentControl.favorites, for: .normal)
        
        favoritesInactiveTitle.titleLabel?.font = Fonts.bold(style: .caption2, traits: traitCollection)
        favoritesInactiveTitle.setTitle(Strings.CategoriesFavoritesSegmentControl.favorites, for: .normal)
        
        categoriesTitle.accessibilityIdentifier = "CategoriesFavoritesSegmentControl.categoriesTitle"
        favoritesTitle.accessibilityIdentifier = "CategoriesFavoritesSegmentControl.favoritesTitle"
        accessibilityIdentifier = "CategoriesFavoritesSegmentControl"
        
        categoriesTitleMask.backgroundColor = UIColor.black.cgColor
        categoriesInactiveTitleMask.backgroundColor = UIColor.black.cgColor
        
        favoritesTitleMask.backgroundColor = UIColor.black.cgColor
        favoritesInactiveTitleMask.backgroundColor = UIColor.black.cgColor
        
        categoriesTitle.layer.mask = categoriesTitleMask
        categoriesInactiveTitle.layer.mask = categoriesInactiveTitleMask
        
        favoritesTitle.layer.mask = favoritesTitleMask
        favoritesInactiveTitle.layer.mask = favoritesInactiveTitleMask
        
        // Setup initial masks offsets
        updateMasksOffsets()
        updateUI()
    }
    
    func updateMasksOffsets() {
        categoriesTitleMask.frame.origin.x = selectionSegment.frame.origin.x - categoriesTitle.frame.minX
        categoriesInactiveTitleMask.frame.origin.x = selectionSegment.frame.origin.x - categoriesTitle.frame.minX
        
        favoritesTitleMask.frame.origin.x = selectionSegment.frame.origin.x - favoritesTitle.frame.minX
        favoritesInactiveTitleMask.frame.origin.x = selectionSegment.frame.origin.x - favoritesTitle.frame.minX
    }
    
    func updateUI() {
        backgroundColor = configuration.style.primaryBackgroundColor
        selectionSegment.backgroundColor = configuration.style.primaryAccentColor
        
        categoriesInactiveTitle.setTitleColor(configuration.style.primaryInactiveElementColor, for: .normal)
        favoritesInactiveTitle.setTitleColor(configuration.style.primaryInactiveElementColor, for: .normal)
        
        categoriesTitle.setTitleColor(configuration.style.activeSegmentTitleColor, for: .normal)
        favoritesTitle.setTitleColor(configuration.style.activeSegmentTitleColor, for: .normal)
    }
    
    @IBAction func tapCategoriesButton() {
        CATransaction.setValue(true, forKey: forceExplicitAnimationTransactionKey)
        selectedTab = .categories
        sendActions(for: .valueChanged)
    }
    
    @IBAction func tapFavoritesButton() {
        CATransaction.setValue(true, forKey: forceExplicitAnimationTransactionKey)
        selectedTab = .favorites
        sendActions(for: .valueChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxComponentWidth = max(categoriesTitle.bounds.width, favoritesTitle.bounds.width)
        let segmentOffsets: CGFloat = 28
        selectionSegment.bounds.size.width = maxComponentWidth + segmentOffsets
        
        categoriesTitleMask.frame.size = selectionSegment.bounds.size
        favoritesTitleMask.frame.size = selectionSegment.bounds.size
        
        let screen = (window?.screen ?? .main)
        let maxInset = max(screen.bounds.width, screen.bounds.height)
        
        let selectionSegmentPath = CGMutablePath()
        selectionSegmentPath.addRect(bounds.insetBy(dx: -maxInset, dy: 0))
        selectionSegmentPath.addRect(selectionSegment.bounds)
        
        categoriesInactiveTitleMask.fillRule = .evenOdd
        categoriesInactiveTitleMask.path = selectionSegmentPath
        
        favoritesInactiveTitleMask.fillRule = .evenOdd
        favoritesInactiveTitleMask.path = selectionSegmentPath
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct TabsSegmentControlRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        // swiftlint:disable:next force_cast
        UINib(nibName: "CategoriesFavoritesSegmentControl", bundle: .mapboxSearchUI).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func updateUIView(_ view: UIView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct CategoriesFavoritesSegmentControlPreview: PreviewProvider {
    static var previews: some View {
        Group {
            TabsSegmentControlRepresentable()
                .previewDisplayName("Light Mode")
                .previewLayout(PreviewLayout.fixed(width: 202, height: 28))
            TabsSegmentControlRepresentable()
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 40))
        }
    }
}
#endif
