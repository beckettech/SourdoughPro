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

    private var readinessColor: Color {
        switch starter.readinessStatus {
        case .readyNow:  return SDColor.success
        case .readySoon: return SDColor.info
        case .pastPeak:  return SDColor.warning
        default:         return SDColor.border
        }
    }

    private var readinessLabel: String? {
        switch starter.readinessStatus {
        case .readyNow:              return "Ready"
        case .readySoon(let mins):
            if mins < 60 { return "~\(mins)m" }
            return "~\(mins / 60)h"
        case .pastPeak:              return "Past peak"
        default:                     return nil
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            // Header row
            HStack {
                // Jar icon with health color ring
                ZStack {
                    Circle()
                        .fill(healthColor.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: SDIcon.starterJar)
                        .font(.system(size: 16))
                        .foregroundStyle(healthColor)
                }
                Spacer()
                // Status indicator dot
                Circle()
                    .fill(healthColor)
                    .frame(width: 8, height: 8)
            }

            // Name
            Text(starter.name)
                .font(SDFont.labelLarge)
                .foregroundStyle(SDColor.textPrimary)
                .lineLimit(1)

            // Health score
            if let score = starter.healthScore {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(String(format: "%.1f", score))
                        .font(SDFont.numberMedium)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("/ 10")
                        .font(SDFont.captionSmall)
                        .foregroundStyle(SDColor.textSecondary)
                }
                SDProgressBar(value: score / 10, style: healthStyle(score))
                    .frame(height: 4)
            }

            // Readiness badge or last fed
            if let label = readinessLabel {
                Text(label)
                    .font(SDFont.captionSmall)
                    .fontWeight(.medium)
                    .foregroundStyle(readinessColor)
                    .padding(.horizontal, SDSpace.s2)
                    .padding(.vertical, 2)
                    .background(readinessColor.opacity(0.12))
                    .clipShape(Capsule())
            } else if let fed = starter.lastFedAt {
                Text("Fed \(fed.relativeDescription)")
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
            }
        }
        .padding(SDSpace.s4)
        .frame(width: 156)
        .background(SDColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.lg)
                .strokeBorder(
                    isSelected ? SDColor.primary : SDColor.borderLight,
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .sdShadow(isSelected ? SDShadow.md : SDShadow.sm)
    }

    private func healthStyle(_ score: Double) -> SDProgressBar.Style {
        if score >= 8 { return .success }
        if score >= 6 { return .warning }
        return .error
    }
}

#Preview {
    HStack {
        StarterChipCard(starter: MockStarters.bubbles, isSelected: true)
        StarterChipCard(starter: MockStarters.bubbles, isSelected: false)
    }
    .padding()
    .sdBackground()
}
