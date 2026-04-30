import SwiftUI

/// Horizontal step-based progress indicator for the bake session.
struct BakeProgressBar: View {
    let totalSteps: Int
    let completedSteps: Int
    let currentStep: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { i in
                Capsule()
                    .fill(segmentColor(for: i))
                    .frame(height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: completedSteps)
    }

    private func segmentColor(for index: Int) -> Color {
        if index < completedSteps { return SDColor.success }
        if index == currentStep   { return SDColor.primary }
        return SDColor.border
    }
}

#Preview {
    BakeProgressBar(totalSteps: 7, completedSteps: 2, currentStep: 2)
        .padding()
        .sdBackground()
}
