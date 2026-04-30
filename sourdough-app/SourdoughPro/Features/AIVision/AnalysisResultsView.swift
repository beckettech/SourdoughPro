import SwiftUI

/// Discriminated union — what kind of analysis are we showing?
enum AIResult {
    case starter(StarterAnalysis)
    case loaf(CrumbAnalysis)
}

struct AnalysisResultsView: View {
    let result: AIResult

    /// Backwards-compat init for callers still passing a `StarterAnalysis` directly.
    init(analysis: StarterAnalysis) { self.result = .starter(analysis) }
    init(result: AIResult)          { self.result = result }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {

                // Score hero — brand surface, make it big
                scoreHero
                    .padding(.horizontal, SDSpace.screenMargin)

                switch result {
                case .starter(let a):
                    if !a.positives.isEmpty {
                        bulletSection(title: "What looks good", items: a.positives,
                                      icon: SDIcon.checkmarkCircle, color: SDColor.success)
                    }
                    if !a.issues.isEmpty {
                        bulletSection(title: "Areas to watch", items: a.issues,
                                      icon: SDIcon.warningTriangle, color: SDColor.warning)
                    }
                    if !a.recommendations.isEmpty {
                        bulletSection(title: "Recommendations", items: a.recommendations,
                                      icon: "lightbulb.fill", color: SDColor.info)
                    }
                case .loaf(let a):
                    subscoresGrid(a)
                    if !a.observations.isEmpty {
                        bulletSection(title: "Observations", items: a.observations,
                                      icon: SDIcon.eye, color: SDColor.info)
                    }
                    if !a.recommendations.isEmpty {
                        bulletSection(title: "Next time, try…", items: a.recommendations,
                                      icon: "lightbulb.fill", color: SDColor.warning)
                    }
                }

                Text("Analysed \(timestamp.relativeDescription)")
                    .font(SDFont.captionSmall)
                    .foregroundStyle(SDColor.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, SDSpace.s4)
            }
            .padding(.vertical, SDSpace.s5)
        }
        .sdBackground()
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Score hero — prominent, brand-surface treatment

    private var scoreHero: some View {
        HStack(alignment: .center, spacing: SDSpace.s6) {
            // Big score number
            VStack(alignment: .leading, spacing: SDSpace.s1) {
                Text(scoreLabel)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
                HStack(alignment: .lastTextBaseline, spacing: SDSpace.s1) {
                    Text(String(format: "%.1f", score))
                        .font(.system(size: 52, weight: .bold, design: .default))
                        .foregroundStyle(scoreColor)
                    Text("/ 10")
                        .font(SDFont.bodyLarge)
                        .foregroundStyle(SDColor.textSecondary)
                }
                SDProgressBar(value: score / 10, style: progressStyle)
                    .frame(height: 6)
            }

            Spacer()

            // Score ring
            ZStack {
                Circle()
                    .stroke(scoreColor.opacity(0.15), lineWidth: 8)
                    .frame(width: 80, height: 80)
                Circle()
                    .trim(from: 0, to: score / 10)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 80, height: 80)
                // Trailing context value
                if let trailing = heroTrailing {
                    VStack(spacing: 1) {
                        Text(trailing.value)
                            .font(SDFont.captionSmall)
                            .fontWeight(.semibold)
                            .foregroundStyle(SDColor.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        Text(trailing.label)
                            .font(.system(size: 9))
                            .foregroundStyle(SDColor.textTertiary)
                    }
                    .frame(width: 60)
                    .multilineTextAlignment(.center)
                }
            }
        }
        .padding(SDSpace.s5)
        .background(SDColor.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.xl)
                .strokeBorder(scoreColor.opacity(0.20), lineWidth: 1)
        )
    }

    // MARK: Loaf subscore grid

    private func subscoresGrid(_ a: CrumbAnalysis) -> some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            SDSectionHeader(title: "Breakdown")
                .padding(.horizontal, SDSpace.screenMargin)
            SDCard {
                VStack(spacing: SDSpace.s4) {
                    subscoreRow(label: "Crumb structure",
                                value: a.crumbStructure.displayName,
                                icon: "circle.grid.cross.fill")
                    Divider()
                    subscoreBar(label: "Fermentation", score: a.fermentationScore)
                    subscoreBar(label: "Shaping",      score: a.shapingScore)
                    subscoreBar(label: "Bake / crust", score: a.bakeScore)
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
    }

    private func subscoreRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: SDSpace.s3) {
            Image(systemName: icon)
                .foregroundStyle(SDColor.primary)
                .frame(width: 24)
            Text(label)
                .font(SDFont.labelMedium)
                .foregroundStyle(SDColor.textPrimary)
            Spacer()
            Text(value)
                .font(SDFont.captionMedium)
                .foregroundStyle(SDColor.textSecondary)
        }
    }

    private func subscoreBar(label: String, score: Double) -> some View {
        VStack(alignment: .leading, spacing: SDSpace.s1) {
            HStack {
                Text(label)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
                Spacer()
                Text(String(format: "%.1f / 10", score))
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textPrimary)
            }
            SDProgressBar(value: score / 10, style: subStyle(score))
        }
    }

    private func subStyle(_ s: Double) -> SDProgressBar.Style {
        if s >= 8 { return .success }
        if s >= 6 { return .warning }
        return .error
    }

    // MARK: Bullet section

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
                                .font(.system(size: 15))
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

    // MARK: Adapters

    private var navTitle: String {
        switch result {
        case .starter: return "Starter Analysis"
        case .loaf:    return "Bake Analysis"
        }
    }

    private var scoreLabel: String {
        switch result {
        case .starter: return "Health Score"
        case .loaf:    return "Overall Score"
        }
    }

    private var score: Double {
        switch result {
        case .starter(let a): return a.healthScore
        case .loaf(let a):    return a.overallScore
        }
    }

    private var heroTrailing: (value: String, label: String)? {
        switch result {
        case .starter(let a):
            if let peak = a.estimatedPeakHours {
                return ("~\(peak)h", "peak")
            }
            return nil
        case .loaf(let a):
            return (a.crumbStructure.displayName, "crumb")
        }
    }

    private var timestamp: Date {
        switch result {
        case .starter(let a): return a.createdAt
        case .loaf(let a):    return a.createdAt
        }
    }

    private var scoreColor: Color {
        if score >= 8 { return SDColor.success }
        if score >= 6 { return SDColor.warning }
        return SDColor.error
    }

    private var progressStyle: SDProgressBar.Style {
        if score >= 8 { return .success }
        if score >= 6 { return .warning }
        return .error
    }
}

#Preview("Starter") {
    NavigationStack {
        AnalysisResultsView(result: .starter(MockAnalyses.starter(for: MockStarters.bubblesId)))
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}

#Preview("Loaf") {
    NavigationStack {
        AnalysisResultsView(result: .loaf(MockAnalyses.crumb(for: UUID())))
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
