import SwiftUI

/// Button component per FIGMA_SPECS.md §Components > Button.
struct SDButton: View {

    enum Style { case primary, secondary, tertiary, destructive }
    enum Size { case large, medium, small
        var height: CGFloat {
            switch self { case .large: return 56; case .medium: return 48; case .small: return 40 }
        }
        var iconSize: CGFloat {
            switch self { case .large: return 20; case .medium: return 18; case .small: return 16 }
        }
        var font: Font {
            switch self {
            case .large:  return SDFont.labelLarge
            case .medium: return SDFont.labelMedium
            case .small:  return SDFont.labelSmall
            }
        }
    }

    let title: String
    var icon: String? = nil
    var iconTrailing: Bool = false
    var style: Style = .primary
    var size: Size = .large
    var fullWidth: Bool = true
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SDSpace.s2) {
                if isLoading {
                    ProgressView().tint(foreground)
                } else {
                    if let icon, !iconTrailing {
                        Image(systemName: icon).font(.system(size: size.iconSize, weight: .medium))
                    }
                    Text(title).font(size.font)
                    if let icon, iconTrailing {
                        Image(systemName: icon).font(.system(size: size.iconSize, weight: .medium))
                    }
                }
            }
            .foregroundStyle(foreground)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: size.height)
            .padding(.horizontal, SDSpace.s6)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: SDRadius.md)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
            .sdShadow(style == .primary && isEnabled ? SDShadow.button : SDShadow(color: .clear, radius: 0, x: 0, y: 0))
        }
        .disabled(!isEnabled || isLoading)
    }

    // MARK: styling
    private var foreground: Color {
        if !isEnabled {
            return style == .primary ? .white : SDColor.textTertiary
        }
        switch style {
        case .primary, .destructive: return .white
        case .secondary, .tertiary:  return SDColor.primary
        }
    }

    private var background: Color {
        if !isEnabled {
            switch style {
            case .primary:     return SDColor.secondaryDark
            case .secondary:   return SDColor.surface
            case .tertiary:    return .clear
            case .destructive: return SDColor.secondaryDark
            }
        }
        switch style {
        case .primary:     return SDColor.primary
        case .secondary:   return SDColor.surface
        case .tertiary:    return .clear
        case .destructive: return SDColor.error
        }
    }

    private var borderColor: Color {
        switch style {
        case .secondary: return isEnabled ? SDColor.primary : SDColor.border
        default:         return .clear
        }
    }

    private var borderWidth: CGFloat { style == .secondary ? 1 : 0 }
}

/// A round icon-only button (44pt tap target).
struct SDIconButton: View {
    let icon: String
    var tint: Color = SDColor.primary
    var background: Color = .clear
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: SDIconSize.md, weight: .regular))
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .background(background)
                .clipShape(Circle())
        }
    }
}

#Preview("SDButton variants") {
    VStack(spacing: 16) {
        SDButton(title: "Primary Large")                                    { }
        SDButton(title: "Primary with Icon", icon: SDIcon.camera)           { }
        SDButton(title: "Secondary", style: .secondary)                     { }
        SDButton(title: "Tertiary",  style: .tertiary)                      { }
        SDButton(title: "Destructive", style: .destructive)                 { }
        SDButton(title: "Medium",  size: .medium)                           { }
        SDButton(title: "Small",   size: .small)                            { }
        SDButton(title: "Loading", isLoading: true)                         { }
        SDButton(title: "Disabled", isEnabled: false)                       { }
    }
    .padding()
    .background(SDColor.background)
}
