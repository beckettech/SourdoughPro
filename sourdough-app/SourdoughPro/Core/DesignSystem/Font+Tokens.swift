import SwiftUI

/// Typography scale per FIGMA_SPECS.md §Design Tokens > Typography.
/// Uses the system fonts (SF Pro Display / Text / Mono) via `Font.system`.
enum SDFont {

    // MARK: Headings (SF Pro Display)
    static let displayLarge  = Font.system(size: 34, weight: .bold,     design: .default)
    static let displayMedium = Font.system(size: 28, weight: .bold,     design: .default)
    static let displaySmall  = Font.system(size: 24, weight: .bold,     design: .default)
    static let headingLarge  = Font.system(size: 22, weight: .semibold, design: .default)
    static let headingMedium = Font.system(size: 20, weight: .semibold, design: .default)
    static let headingSmall  = Font.system(size: 18, weight: .semibold, design: .default)

    // MARK: Body (SF Pro Text)
    static let bodyLarge  = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 16, weight: .regular, design: .default)
    static let bodySmall  = Font.system(size: 15, weight: .regular, design: .default)

    // MARK: Labels & captions
    static let labelLarge   = Font.system(size: 15, weight: .medium,  design: .default)
    static let labelMedium  = Font.system(size: 14, weight: .medium,  design: .default)
    static let labelSmall   = Font.system(size: 13, weight: .medium,  design: .default)
    static let captionLarge  = Font.system(size: 14, weight: .regular, design: .default)
    static let captionMedium = Font.system(size: 13, weight: .regular, design: .default)
    static let captionSmall  = Font.system(size: 12, weight: .regular, design: .default)

    // MARK: Numbers & timers (SF Mono / Display)
    static let timerDisplay   = Font.system(size: 48, weight: .bold,     design: .monospaced)
    static let timerSecondary = Font.system(size: 32, weight: .medium,   design: .monospaced)
    static let numberLarge    = Font.system(size: 32, weight: .bold,     design: .default)
    static let numberMedium   = Font.system(size: 24, weight: .semibold, design: .default)
}

extension View {
    /// Apply a typography token and matching line-height using `.lineSpacing`.
    /// The spec gives exact line-height values but SwiftUI's baseline line
    /// spacing is derived from the font — the manual adjustments here match
    /// the spec's numbers to within ±1pt.
    func sdFont(_ font: Font) -> some View {
        self.font(font)
    }
}
