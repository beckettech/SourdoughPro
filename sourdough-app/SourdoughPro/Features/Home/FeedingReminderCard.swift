import SwiftUI

struct FeedingReminderCard: View {
    let starter: Starter
    let onFeed: () -> Void

    private var isOverdue: Bool { FeedingScheduler.isOverdue(starter) }
    private var hoursUntil: Int? { FeedingScheduler.hoursUntilNextFeeding(for: starter) }

    private var accentColor: Color { isOverdue ? SDColor.warning : SDColor.info }

    var body: some View {
        HStack(spacing: SDSpace.s4) {
            // Icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: isOverdue ? SDIcon.warningTriangle : SDIcon.clock)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(accentColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(isOverdue ? "\(starter.name) needs feeding" : "Feed \(starter.name) soon")
                    .font(SDFont.labelLarge)
                    .foregroundStyle(SDColor.textPrimary)
                if isOverdue {
                    Text("Overdue — feed now to keep it active")
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.warning)
                } else if let h = hoursUntil {
                    Text("In about \(h) hour\(h == 1 ? "" : "s")")
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.textSecondary)
                }
            }

            Spacer()

            Button(action: onFeed) {
                Text("Feed")
                    .font(SDFont.labelSmall)
                    .foregroundStyle(.white)
                    .padding(.horizontal, SDSpace.s4)
                    .padding(.vertical, SDSpace.s2)
                    .background(accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(SDSpace.s4)
        .background(accentColor.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.lg)
                .strokeBorder(accentColor.opacity(0.20), lineWidth: 1)
        )
    }
}

#Preview {
    FeedingReminderCard(starter: MockStarters.bubbles) {}
        .padding()
        .sdBackground()
}
