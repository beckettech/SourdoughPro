import SwiftUI

/// 4-pt spacing scale per FIGMA_SPECS.md §Design Tokens > Spacing.
enum SDSpace {
    static let s0: CGFloat  = 0
    static let s1: CGFloat  = 4
    static let s2: CGFloat  = 8
    static let s3: CGFloat  = 12
    static let s4: CGFloat  = 16
    static let s5: CGFloat  = 20
    static let s6: CGFloat  = 24
    static let s7: CGFloat  = 28
    static let s8: CGFloat  = 32
    static let s10: CGFloat = 40
    static let s12: CGFloat = 48
    static let s16: CGFloat = 64
    static let s20: CGFloat = 80
    static let s24: CGFloat = 96

    /// Standard screen horizontal margin.
    static let screenMargin: CGFloat = 16
    static let screenMarginCompact: CGFloat = 12
    static let screenMarginRelaxed: CGFloat = 24
    /// Alias for screenMarginRelaxed — used in paywall / settings.
    static let screenMarginLg: CGFloat = 24
}
