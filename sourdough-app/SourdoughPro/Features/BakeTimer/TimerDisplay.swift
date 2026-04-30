import SwiftUI

struct TimerDisplay: View {
    let secondsRemaining: Int
    let isRunning: Bool

    private var hours: Int   { secondsRemaining / 3600 }
    private var minutes: Int { (secondsRemaining % 3600) / 60 }
    private var secs: Int    { secondsRemaining % 60 }

    var body: some View {
        HStack(spacing: 4) {
            if hours > 0 {
                timeUnit(value: hours,   label: "hr")
                Text(":").font(SDFont.timerDisplay).foregroundStyle(SDColor.textSecondary)
            }
            timeUnit(value: minutes, label: "min")
            Text(":").font(SDFont.timerDisplay).foregroundStyle(SDColor.textSecondary)
            timeUnit(value: secs,    label: "sec")
        }
        .opacity(isRunning ? 1 : 0.6)
        .animation(.easeInOut(duration: 0.3), value: isRunning)
    }

    private func timeUnit(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text(String(format: "%02d", value))
                .font(SDFont.timerDisplay)
                .foregroundStyle(SDColor.textPrimary)
                .monospacedDigit()
            Text(label)
                .font(SDFont.captionSmall)
                .foregroundStyle(SDColor.textSecondary)
        }
    }
}

#Preview {
    VStack(spacing: SDSpace.s6) {
        TimerDisplay(secondsRemaining: 4523, isRunning: true)
        TimerDisplay(secondsRemaining: 90,   isRunning: false)
    }
    .padding()
    .sdBackground()
}
