import SwiftUI

/// Progress bar per FIGMA_SPECS.md §Components > Progress Bar.
struct SDProgressBar: View {

    enum Size { case small, medium, large
        var height: CGFloat {
            switch self { case .small: return 4; case .medium: return 8; case .large: return 12 }
        }
    }

    enum Style {
        case `default`, health, success, warning, error
        var color: Color {
            switch self {
            case .default:   return SDColor.primary
            case .health:    return SDColor.primary   // overridden dynamically
            case .success:   return SDColor.success
            case .warning:   return SDColor.warning
            case .error:     return SDColor.error
            }
        }
    }

    /// Value between 0.0 and 1.0.
    let value: Double
    var size: Size = .medium
    var style: Style = .default
    /// If true, the fill colour shifts from error→warning→success based on `value`.
    var healthVariant: Bool = false
    var fillColor: Color = SDColor.primary

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(SDColor.secondaryDark)
                Capsule()
                    .fill(resolvedFill)
                    .frame(width: max(0, min(1, value)) * geo.size.width)
                    .animation(.easeOut(duration: 0.3), value: value)
            }
        }
        .frame(height: size.height)
    }

    private var resolvedFill: Color {
        if style == .health || healthVariant {
            switch value * 10 {
            case ..<4:  return SDColor.error
            case ..<7:  return SDColor.warning
            default:    return SDColor.success
            }
        }
        if style != .default { return style.color }
        return fillColor
    }
}

#Preview("SDProgressBar") {
    VStack(spacing: 20) {
        SDProgressBar(value: 0.85, healthVariant: true)
        SDProgressBar(value: 0.55, healthVariant: true)
        SDProgressBar(value: 0.25, healthVariant: true)
        SDProgressBar(value: 0.4, size: .small)
        SDProgressBar(value: 0.7, size: .large)
    }
    .padding().background(SDColor.background)
}
