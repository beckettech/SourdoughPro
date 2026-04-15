import SwiftUI

/// Semantic color tokens per FIGMA_SPECS.md §Design Tokens > Colors.
///
/// All tokens are exposed as `static let`s on `SDColor`. Dark mode variants
/// have been added as an improvement over the base spec — the palette keeps
/// the warm bread/flour feeling while shifting to lower-luminance surfaces.
enum SDColor {

    // MARK: Primary palette
    static let primary       = Color(hex: "#8B4513") // Saddle Brown
    static let primaryLight  = Color(hex: "#A0522D") // Sienna (hover)
    static let primaryDark   = Color(hex: "#5D2E0C") // Dark Brown (pressed)

    // MARK: Secondary palette
    static let secondary      = Color(hex: "#F5DEB3") // Wheat
    static let secondaryLight = Color(hex: "#FFF8DC") // Cornsilk
    static let secondaryDark  = Color(hex: "#D2B48C") // Tan (borders)

    // MARK: Accent palette
    static let accent      = Color(hex: "#D2691E") // Chocolate
    static let accentLight = Color(hex: "#E07B2F")

    // MARK: Background palette — adaptive (light/dark)
    static let background       = adaptive(light: "#FFFAF0", dark: "#1C1410")
    static let surface          = adaptive(light: "#FFFFFF", dark: "#2A1F18")
    static let surfaceElevated  = adaptive(light: "#FEFCF7", dark: "#33261C")

    // MARK: Semantic palette
    static let success      = Color(hex: "#228B22")
    static let successLight = Color(hex: "#32CD32")
    static let successBg    = adaptive(light: "#E8F5E9", dark: "#1E3A1E")

    static let warning   = Color(hex: "#DAA520")
    static let warningBg = adaptive(light: "#FFF8E1", dark: "#3D2F10")

    static let error   = Color(hex: "#8B0000")
    static let errorBg = adaptive(light: "#FFEBEE", dark: "#3D1414")

    static let info   = Color(hex: "#1976D2")
    static let infoBg = adaptive(light: "#E3F2FD", dark: "#102640")

    // MARK: Text palette — adaptive
    static let textPrimary   = adaptive(light: "#2C1810", dark: "#F5EBE0")
    static let textSecondary = adaptive(light: "#8B7355", dark: "#C4A77D")
    static let textTertiary  = adaptive(light: "#A89078", dark: "#8B7355")
    static let textInverted  = Color.white
    static let textLink      = Color(hex: "#8B4513")

    // MARK: Border palette — adaptive
    static let border      = adaptive(light: "#E5D5C3", dark: "#3D2E20")
    static let borderLight = adaptive(light: "#F0E8DC", dark: "#2D2218")
    static let borderDark  = adaptive(light: "#C4A77D", dark: "#5D4530")

    // MARK: Overlay palette
    static let overlayLight  = Color.black.opacity(0.04)
    static let overlayMedium = Color.black.opacity(0.08)
    static let overlayDark   = Color.black.opacity(0.48)

    // MARK: Adaptive helper
    private static func adaptive(light: String, dark: String) -> Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(Color(hex: dark))
                : UIColor(Color(hex: light))
        })
    }
}
