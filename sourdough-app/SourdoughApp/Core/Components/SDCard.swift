import SwiftUI

/// Card container per FIGMA_SPECS.md §Components > Card.
struct SDCard<Content: View>: View {

    enum Variant { case `default`, elevated, interactive, accent(Color) }

    var variant: Variant = .default
    var padding: CGFloat = SDSpace.s4
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(background)
            .overlay(leadingAccent, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
            .sdShadow(shadow)
    }

    private var background: Color {
        switch variant {
        case .default, .interactive: return SDColor.surface
        case .elevated:              return SDColor.surfaceElevated
        case .accent:                return SDColor.successBg
        }
    }

    private var shadow: SDShadow {
        switch variant {
        case .default, .interactive, .accent: return SDShadow.card
        case .elevated:                       return SDShadow.lg
        }
    }

    @ViewBuilder
    private var leadingAccent: some View {
        if case let .accent(color) = variant {
            Rectangle().fill(color).frame(width: 4)
        }
    }
}

#Preview("SDCard") {
    VStack(spacing: 16) {
        SDCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Default card").font(SDFont.headingSmall)
                Text("With some supporting body text below.").font(SDFont.bodyMedium)
            }
        }
        SDCard(variant: .elevated) {
            Text("Elevated card").font(SDFont.headingSmall)
        }
        SDCard(variant: .accent(SDColor.success)) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Bubbles needs feeding!").font(SDFont.headingSmall)
                Text("Last fed: 18 hours ago").font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
            }
        }
    }
    .padding()
    .background(SDColor.background)
}
