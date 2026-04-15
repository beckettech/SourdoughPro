import SwiftUI

/// Chip / Tag per FIGMA_SPECS.md §Components > Chip / Tag.
struct SDChip: View {

    enum Style { case defaultStyle, selected, success, warning, error, info }

    let text: String
    var icon: String? = nil
    var style: Style = .defaultStyle

    var body: some View {
        HStack(spacing: SDSpace.s1) {
            if let icon {
                Image(systemName: icon).font(.system(size: 12, weight: .medium))
            }
            Text(text).font(SDFont.labelSmall)
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, SDSpace.s3)
        .frame(height: 32)
        .background(background)
        .clipShape(Capsule())
    }

    private var foreground: Color {
        switch style {
        case .defaultStyle:       return SDColor.textPrimary
        case .selected:           return .white
        case .success:            return SDColor.success
        case .warning:            return SDColor.warning
        case .error:              return SDColor.error
        case .info:               return SDColor.info
        }
    }
    private var background: Color {
        switch style {
        case .defaultStyle: return SDColor.secondary
        case .selected:     return SDColor.primary
        case .success:      return SDColor.successBg
        case .warning:      return SDColor.warningBg
        case .error:        return SDColor.errorBg
        case .info:         return SDColor.infoBg
        }
    }
}

#Preview("SDChip") {
    VStack(alignment: .leading, spacing: 12) {
        HStack { SDChip(text: "Bread flour"); SDChip(text: "Selected", style: .selected) }
        HStack { SDChip(text: "Healthy", icon: SDIcon.checkmark, style: .success); SDChip(text: "Needs feeding", icon: SDIcon.bell, style: .warning); SDChip(text: "Problem", icon: SDIcon.errorCircle, style: .error) }
    }.padding().background(SDColor.background)
}
