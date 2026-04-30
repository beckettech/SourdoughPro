import SwiftUI

/// Semantic color tokens — Golden Amber edition.
///
/// Primary palette shifted from Saddle Brown → warm Amber Gold (like a
/// perfectly baked crust). Surfaces keep a honey-warm tint in both modes.
enum SDColor {

    // MARK: Primary palette  —  Amber Gold
    static let primary       = Color(hex: "#C8860A") // Amber Gold
    static let primaryLight  = Color(hex: "#D49914") // Lighter Amber (hover)
    static let primaryDark   = Color(hex: "#8A5C06") // Deep Amber (pressed)

    // MARK: Secondary palette  —  warm wheat/honey tones
    static let secondary      = Color(hex: "#F5DEB3") // Wheat
    static let secondaryLight = Color(hex: "#FFFAED") // Honey cream
    static let secondaryDark  = Color(hex: "#D4B896") // Warm tan

    // MARK: Accent palette  —  bright gold
    static let accent      = Color(hex: "#E6B422") // Bright Gold
    static let accentLight = Color(hex: "#F0C740") // Pale Gold

    // MARK: Background palette — adaptive (light / dark)
    static let background       = adaptive(light: "#FFFEF5", dark: "#1A1600")
    static let surface          = adaptive(light: "#FFFFFF", dark: "#261E00")
    static let surfaceElevated  = adaptive(light: "#FFFDF0", dark: "#302800")

    // MARK: Semantic palette
    static let success      = Color(hex: "#228B22")
    static let successLight = Color(hex: "#32CD32")
    static let successBg    = adaptive(light: "#E8F5E9", dark: "#1E3A1E")

    static let warning   = Color(hex: "#E07B2F") // Warm orange — distinct from golden primary
    static let warningBg = adaptive(light: "#FFF3E0", dark: "#3D2000")

    static let error   = Color(hex: "#C0392B")
    static let errorBg = adaptive(light: "#FFEBEE", dark: "#3D1414")

    static let info   = Color(hex: "#1976D2")
    static let infoBg = adaptive(light: "#E3F2FD", dark: "#102640")

    // MARK: Text palette — adaptive
    static let textPrimary   = adaptive(light: "#2C2000", dark: "#FFF3D0")
    static let textSecondary = adaptive(light: "#8B7040", dark: "#C4A55A")
    static let textTertiary  = adaptive(light: "#A89060", dark: "#8B7040")
    static let textInverted  = Color.white
    static let textLink      = Color(hex: "#C8860A")

    // MARK: Border palette — adaptive
    static let border      = adaptive(light: "#E8D5A0", dark: "#3D3000")
    static let borderLight = adaptive(light: "#F2EAC8", dark: "#2D2400")
    static let borderDark  = adaptive(light: "#C4A840", dark: "#5D4A00")

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
