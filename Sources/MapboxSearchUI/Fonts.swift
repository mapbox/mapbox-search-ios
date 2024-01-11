import UIKit

enum Fonts {
    static func `default`(style: UIFont.TextStyle, traits: UITraitCollection?) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let font = fontCollection(fontName: "AvenirNext-Medium")[style]!
        return metrics.scaledFont(for: font, compatibleWith: traits)
    }

    static func bold(style: UIFont.TextStyle, traits: UITraitCollection?) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let font = fontCollection(fontName: "AvenirNext-Bold")[style]!
        return metrics.scaledFont(for: font, compatibleWith: traits)
    }

    // Based on https://sarunw.com/posts/scaling-custom-fonts-automatically-with-dynamic-type/
    private static func fontCollection(fontName: String) -> [UIFont.TextStyle: UIFont] {
        [
            .largeTitle: UIFont(name: fontName, size: 34)!,
            .title1: UIFont(name: fontName, size: 28)!,
            .title2: UIFont(name: fontName, size: 22)!,
            .title3: UIFont(name: fontName, size: 20)!,
            .headline: UIFont(name: fontName, size: 17)!,
            .body: UIFont(name: fontName, size: 17)!,
            .callout: UIFont(name: fontName, size: 16)!,
            .subheadline: UIFont(name: fontName, size: 15)!,
            .footnote: UIFont(name: fontName, size: 13)!,
            .caption1: UIFont(name: fontName, size: 12)!,
            .caption2: UIFont(name: fontName, size: 11)!
        ]
    }
}
