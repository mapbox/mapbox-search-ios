// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TabsSegmentControlRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let segmentControl: CategoriesFavoritesSegmentControl = UINib(
            nibName: "CategoriesFavoritesSegmentControl",
            bundle: .mapboxSearchUI
        )
        .instantiate(withOwner: nil, options: nil)[0] as! CategoriesFavoritesSegmentControl
        // swiftlint:disable:previous force_cast

        segmentControl.configuration = Configuration()

        return segmentControl
    }

    func updateUIView(_ view: UIView, context: Context) {}
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
                .previewLayout(PreviewLayout.fixed(width: 202, height: 28))
                .previewLayout(.sizeThatFits)
            TabsSegmentControlRepresentable()
                .previewDisplayName("Right to Left")
                .previewLayout(PreviewLayout.fixed(width: 202, height: 28))
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
