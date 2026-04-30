import SwiftUI

/// Compact banner shown on HomeView answering "Should I bake today?"
/// Backed by the Starter+Readiness extension so logic stays in one place.
struct StarterReadinessBanner: View {
    let starter: Starter

    var body: some View {
        let status = starter.readinessStatus
        // Don't show anything when there's no data yet — the starter chip already
        // shows "no feedings" context; a blank banner just adds noise.
        if case .noData = status { return AnyView(EmptyView()) }
        if case .notFedYet = status { return AnyView(EmptyView()) }
        return AnyView(banner(status: status))
    }

    private func banner(status: ReadinessStatus) -> some View {
        HStack(spacing: SDSpace.s3) {
            Image(systemName: iconName(status))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(bannerColor(status))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title(status))
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textPrimary)
                Text(subtitle(status))
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
            }

            Spacer()

            // Subtle pulsing dot
            Circle()
                .fill(bannerColor(status))
                .frame(width: 10, height: 10)
        }
        .padding(SDSpace.s4)
        .background(bannerColor(status).opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.md)
                .stroke(bannerColor(status).opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
    }

    // MARK: - Adapters

    private func iconName(_ status: ReadinessStatus) -> String {
        switch status {
        case .readyNow:  return "checkmark.circle.fill"
        case .readySoon: return "clock.fill"
        case .pastPeak:  return "exclamationmark.triangle.fill"
        default:         return "clock.badge.questionmark"
        }
    }

    private func bannerColor(_ status: ReadinessStatus) -> Color {
        switch status {
        case .readyNow:  return SDColor.success
        case .readySoon: return SDColor.info
        case .pastPeak:  return SDColor.warning
        default:         return SDColor.textTertiary
        }
    }

    private func title(_ status: ReadinessStatus) -> String {
        switch status {
        case .readyNow:              return "\(starter.name) is ready to bake!"
        case .readySoon(let mins):   return "\(starter.name) ready in ~\(formatMins(mins))"
        case .pastPeak(let mins):    return "\(starter.name) peaked \(formatMins(mins)) ago"
        default: return ""
        }
    }

    private func subtitle(_ status: ReadinessStatus) -> String {
        switch status {
        case .readyNow(let since):
            return since == 0 ? "At peak activity — bake now for best results." : "Past peak by ~\(formatMins(since)). Bake soon."
        case .readySoon(let mins):
            return "Give it about \(formatMins(mins)) before shaping."
        case .pastPeak(let mins):
            return "\(formatMins(mins)) past ideal window. Feed to reset."
        default: return ""
        }
    }

    private func formatMins(_ mins: Int) -> String {
        if mins < 60 { return "\(mins)m" }
        let h = mins / 60; let m = mins % 60
        return m > 0 ? "\(h)h \(m)m" : "\(h)h"
    }
}

#Preview("Ready now") {
    StarterReadinessBanner(starter: MockStarters.bubbles)
        .padding()
        .background(SDColor.background)
}
