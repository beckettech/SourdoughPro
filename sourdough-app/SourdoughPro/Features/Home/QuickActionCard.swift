import SwiftUI

struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
}

struct QuickActionCard: View {
    let action: QuickAction

    var body: some View {
        Button(action: action.action) {
            VStack(alignment: .leading, spacing: SDSpace.s3) {
                // Icon in an amber circle
                ZStack {
                    Circle()
                        .fill(SDColor.primary.opacity(0.10))
                        .frame(width: 44, height: 44)
                    Image(systemName: action.icon)
                        .font(.system(size: SDIconSize.sm, weight: .semibold))
                        .foregroundStyle(SDColor.primary)
                }

                VStack(alignment: .leading, spacing: SDSpace.s1) {
                    Text(action.title)
                        .font(SDFont.labelMedium)
                        .foregroundStyle(SDColor.textPrimary)
                        .lineLimit(1)
                    Text(action.subtitle)
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(SDSpace.s4)
            .frame(width: 140, height: 124)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(SDColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: SDRadius.lg)
                    .strokeBorder(SDColor.borderLight, lineWidth: 1)
            )
            .sdShadow(SDShadow.card)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        QuickActionCard(action: QuickAction(
            icon: SDIcon.recipe,
            title: "New Bake",
            subtitle: "Pick a recipe",
            action: {}))
        QuickActionCard(action: QuickAction(
            icon: SDIcon.camera,
            title: "AI Scan",
            subtitle: "Check starter health",
            action: {}))
    }
    .padding()
    .sdBackground()
}
