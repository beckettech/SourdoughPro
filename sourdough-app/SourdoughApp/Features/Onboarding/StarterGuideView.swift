import SwiftUI

private struct GuideStep: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let body: String
}

private let guideSteps: [GuideStep] = [
    GuideStep(icon: "drop.fill",
              title: "Keep it fed",
              body: "Discard half your starter and feed equal weights of flour and water every 12–24 hours. Regularity is everything."),
    GuideStep(icon: "thermometer.medium",
              title: "Temperature matters",
              body: "Room temperature (70–75°F / 21–24°C) is the sweet spot. Warmer speeds fermentation; cooler slows it."),
    GuideStep(icon: "arrow.up.forward",
              title: "Watch it rise",
              body: "A healthy starter doubles in 4–8 hours after feeding. Use a rubber band to track the rise."),
    GuideStep(icon: "nose",
              title: "Trust your nose",
              body: "It should smell pleasantly sour — like yogurt or beer. Sharp acetone smells mean it needs more frequent feeds."),
    GuideStep(icon: "checkmark.seal.fill",
              title: "The float test",
              body: "Drop a small spoonful into water. If it floats, your starter is ready to bake with. If it sinks, feed again."),
]

struct StarterGuideView: View {
    @EnvironmentObject private var appState: AppState
    @State private var pageIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            // Progress dots
            HStack(spacing: SDSpace.s2) {
                ForEach(0..<guideSteps.count, id: \.self) { i in
                    Capsule()
                        .fill(i == pageIndex ? SDColor.primary : SDColor.border)
                        .frame(width: i == pageIndex ? 24 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.25), value: pageIndex)
                }
            }
            .padding(.top, SDSpace.s4)

            // Content
            TabView(selection: $pageIndex) {
                ForEach(Array(guideSteps.enumerated()), id: \.offset) { idx, step in
                    StepCard(step: step)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)

            // Action buttons
            VStack(spacing: SDSpace.s3) {
                if pageIndex < guideSteps.count - 1 {
                    SDButton(title: "Next") { pageIndex += 1 }
                    Button("Skip to app") { appState.completeOnboarding() }
                        .font(SDFont.labelMedium)
                        .foregroundStyle(SDColor.textSecondary)
                        .frame(height: 44)
                } else {
                    SDButton(title: "Start baking!") { appState.completeOnboarding() }
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.bottom, SDSpace.s8)
        }
        .sdBackground()
        .navigationTitle("Starter Guide")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

private struct StepCard: View {
    let step: GuideStep

    var body: some View {
        VStack(spacing: SDSpace.s6) {
            Spacer()

            ZStack {
                Circle()
                    .fill(SDColor.secondary.opacity(0.5))
                    .frame(width: 120, height: 120)
                Image(systemName: step.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                    .foregroundStyle(SDColor.primary)
            }

            VStack(spacing: SDSpace.s3) {
                Text(step.title)
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .multilineTextAlignment(.center)

                Text(step.body)
                    .font(SDFont.bodyLarge)
                    .foregroundStyle(SDColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, SDSpace.screenMargin)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack { StarterGuideView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
