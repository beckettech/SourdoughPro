import SwiftUI

struct AnalysisResultsView: View {
    let analysis: StarterAnalysis

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {

                // Score hero
                SDCard(variant: .elevated) {
                    VStack(spacing: SDSpace.s4) {
                        HStack {
                            VStack(alignment: .leading, spacing: SDSpace.s1) {
                                Text("Health Score")
                                    .font(SDFont.labelMedium)
                                    .foregroundStyle(SDColor.textSecondary)
                                HStack(alignment: .lastTextBaseline, spacing: SDSpace.s1) {
                                    Text(String(format: "%.1f", analysis.healthScore))
                                        .font(SDFont.numberLarge)
                                        .foregroundStyle(scoreColor)
                                    Text("/ 10")
                                        .font(SDFont.bodyLarge)
                                        .foregroundStyle(SDColor.textSecondary)
                                }
                            }
                            Spacer()
                            if let peak = analysis.estimatedPeakHours {
                                VStack(alignment: .trailing, spacing: SDSpace.s1) {
                                    Text("Peak in ~\(peak)h")
                                        .font(SDFont.labelMedium)
                                        .foregroundStyle(SDColor.textPrimary)
                                    Text("Bake window")
                                        .font(SDFont.captionSmall)
                                        .foregroundStyle(SDColor.textSecondary)
                                }
                            }
                        }
                        SDProgressBar(value: analysis.healthScore / 10, style: progressStyle)
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)

                // Positives
                if !analysis.positives.isEmpty {
                    bulletSection(title: "What looks good", items: analysis.positives,
                                  icon: "checkmark.circle.fill", color: SDColor.success)
                }

                // Issues
                if !analysis.issues.isEmpty {
                    bulletSection(title: "Areas to watch", items: analysis.issues,
                                  icon: "exclamationmark.triangle.fill", color: SDColor.warning)
                }

                // Recommendations
                if !analysis.recommendations.isEmpty {
                    bulletSection(title: "Recommendations", items: analysis.recommendations,
                                  icon: "lightbulb.fill", color: SDColor.info)
                }

                // Analysed at
                Text("Analysed \(analysis.createdAt.relativeDescription)")
                    .font(SDFont.captionSmall)
                    .foregroundStyle(SDColor.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, SDSpace.s4)
            }
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle("AI Analysis")
        .navigationBarTitleDisplayMode(.large)
    }

    private var scoreColor: Color {
        if analysis.healthScore >= 8 { return SDColor.success }
        if analysis.healthScore >= 6 { return SDColor.warning }
        return SDColor.error
    }

    private var progressStyle: SDProgressBar.Style {
        if analysis.healthScore >= 8 { return .success }
        if analysis.healthScore >= 6 { return .warning }
        return .error
    }

    private func bulletSection(title: String, items: [String], icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            SDSectionHeader(title: title)
                .padding(.horizontal, SDSpace.screenMargin)
            SDCard {
                VStack(alignment: .leading, spacing: SDSpace.s3) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: SDSpace.s3) {
                            Image(systemName: icon)
                                .foregroundStyle(color)
                                .font(.system(size: 16))
                                .frame(width: 20)
                            Text(item)
                                .font(SDFont.bodySmall)
                                .foregroundStyle(SDColor.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
    }
}

#Preview {
    NavigationStack {
        AnalysisResultsView(analysis: MockAnalyses.starter(for: MockStarters.bubblesId))
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
