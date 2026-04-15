import SwiftUI

struct StarterChipCard: View {
    let starter: Starter
    let isSelected: Bool

    private var healthColor: Color {
        guard let score = starter.healthScore else { return SDColor.border }
        if score >= 8 { return SDColor.success }
        if score >= 6 { return SDColor.warning }
        return SDColor.error
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            // Header row
            HStack {
                Text(starter.name)
                    .font(SDFont.headingSmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .lineLimit(1)
                Spacer()
                Circle()
                    .fill(healthColor)
                    .frame(width: 8, height: 8)
            }

            // Health score + bar
            if let score = starter.healthScore {
                HStack(alignment: .lastTextBaseline, spacing: SDSpace.s1) {
                    Text(String(format: "%.1f", score))
                        .font(SDFont.numberLarge)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("/ 10")
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.textSecondary)
                }
                SDProgressBar(value: score / 10)
                    .frame(height: 8)
            }

            // Last fed label
            if let fed = starter.lastFedAt {
                Text("Fed \(fed.relativeDescription)")
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
            }
        }
        .padding(SDSpace.s4)
        .frame(width: 160)
        .background(SDColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.lg)
                .strokeBorder(isSelected ? SDColor.primary : Color.clear, lineWidth: 2)
        )
        .sdShadow(SDShadow.card)
    }
}

#Preview {
    HStack {
        StarterChipCard(starter: MockStarters.bubbles, isSelected: true)
        StarterChipCard(starter: MockStarters.gerty,   isSelected: false)
    }
    .padding()
    .sdBackground()
}
