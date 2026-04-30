import SwiftUI

struct BakeStepView: View {
    let step: RecipeStep
    let stepNumber: Int
    let totalSteps: Int
    let secondsRemaining: Int
    let timerRunning: Bool
    let onComplete: () -> Void
    let onToggleTimer: () -> Void

    var body: some View {
        VStack(spacing: SDSpace.s6) {
            // Step title
            VStack(spacing: SDSpace.s2) {
                Text("Step \(stepNumber) of \(totalSteps)")
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textSecondary)
                Text(step.title)
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .multilineTextAlignment(.center)
                if let type = step.timerType {
                    SDChip(text: type.displayName, style: .info)
                }
            }

            // Timer
            if let dur = step.durationMinutes, dur > 0 {
                VStack(spacing: SDSpace.s4) {
                    TimerDisplay(secondsRemaining: secondsRemaining, isRunning: timerRunning)

                    // Timer progress ring
                    let total = Double(dur * 60)
                    let elapsed = total - Double(max(0, secondsRemaining))
                    let progress = total > 0 ? elapsed / total : 0

                    ZStack {
                        Circle()
                            .stroke(SDColor.border, lineWidth: 8)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(SDColor.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progress)
                    }
                    .frame(width: 120, height: 120)

                    Button(action: onToggleTimer) {
                        Label(timerRunning ? "Pause" : "Start Timer",
                              systemImage: timerRunning ? "pause.fill" : "play.fill")
                            .font(SDFont.labelMedium)
                            .foregroundStyle(SDColor.primary)
                    }
                }
            }

            // Instructions card
            SDCard {
                Text(step.instructions)
                    .font(SDFont.bodyMedium)
                    .foregroundStyle(SDColor.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            // Complete step button
            SDButton(title: stepNumber == totalSteps ? "Finish Bake" : "Complete Step") {
                onComplete()
            }
        }
        .padding(.horizontal, SDSpace.screenMargin)
    }
}

#Preview {
    BakeStepView(
        step: MockRecipes.classicSourdough.steps[0],
        stepNumber: 1,
        totalSteps: 7,
        secondsRemaining: 4523,
        timerRunning: true,
        onComplete: {},
        onToggleTimer: {}
    )
    .sdBackground()
}
