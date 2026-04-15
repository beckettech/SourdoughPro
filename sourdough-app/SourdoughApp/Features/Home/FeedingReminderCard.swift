import SwiftUI

struct FeedingReminderCard: View {
    let starter: Starter
    let onFeed: () -> Void

    private var isOverdue: Bool { FeedingScheduler.isOverdue(starter) }
    private var hoursUntil: Int? { FeedingScheduler.hoursUntilNextFeeding(for: starter) }

    var body: some View {
        SDCard {
            HStack(spacing: SDSpace.s4) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isOverdue ? SDColor.warningBg : SDColor.successBg)
                        .frame(width: 48, height: 48)
                    Image(systemName: isOverdue ? "exclamationmark.circle.fill" : "clock.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(isOverdue ? SDColor.warning : SDColor.success)
                }

                VStack(alignment: .leading, spacing: SDSpace.s1) {
                    Text(isOverdue ? "\(starter.name) needs feeding!" : "Feed \(starter.name) soon")
                        .font(SDFont.labelLarge)
                        .foregroundStyle(SDColor.textPrimary)
                    if isOverdue {
                        Text("Overdue — feed now to keep it healthy")
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
                        .foregroundStyle(SDColor.textInverted)
                        .padding(.horizontal, SDSpace.s4)
                        .padding(.vertical, SDSpace.s2)
                        .background(SDColor.primary)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

#Preview {
    FeedingReminderCard(starter: MockStarters.bubbles) {}
        .padding()
        .sdBackground()
}
