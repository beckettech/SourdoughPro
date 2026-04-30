import SwiftUI

@MainActor
final class StarterDetailViewModel: ObservableObject {
    @Published var starter: Starter
    @Published var isLoading = false
    @Published var showAddFeeding = false
    @Published var showEdit = false

    init(starter: Starter) {
        self.starter = starter
    }

    func refresh(services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        if let updated = try? await services.starters.getStarter(starter.id) {
            starter = updated
        }
    }

    func deleteFeeding(_ feeding: Feeding, services: ServiceContainer) {
        starter.feedings.removeAll { $0.id == feeding.id }
        Task { try? await services.starters.deleteFeeding(feeding.id, starterId: starter.id) }
    }

    // MARK: Peak / readiness prediction (delegates to Starter+Readiness extension)

    var averagePeakMinutes: Int? { starter.averagePeakMinutes }
    var readinessStatus: ReadinessStatus { starter.readinessStatus }
}

struct StarterDetailView: View {
    @Environment(\.services) private var services
    @StateObject private var vm: StarterDetailViewModel
    @State private var navigateToCamera = false
    @State private var navigateToDiscard = false

    init(starter: Starter) {
        _vm = StateObject(wrappedValue: StarterDetailViewModel(starter: starter))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {

                // Health score hero card
                healthCard

                // Metadata row
                metaRow

                // Ready to bake? card
                readinessCard

                // Action buttons
                HStack(spacing: SDSpace.s3) {
                    SDButton(title: "AI Health Check", icon: SDIcon.sparkles, style: .secondary) {
                        navigateToCamera = true
                    }
                    SDButton(title: "Add Feeding", icon: SDIcon.drop) {
                        vm.showAddFeeding = true
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)

                // Feeding history
                feedingHistory

                // Notes
                if !vm.starter.notes.isEmpty {
                    VStack(alignment: .leading, spacing: SDSpace.s2) {
                        SDSectionHeader(title: "Notes")
                        Text(vm.starter.notes)
                            .font(SDFont.bodyMedium)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                    .padding(.horizontal, SDSpace.screenMargin)
                }
            }
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle(vm.starter.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button { vm.showEdit = true } label: { Label("Edit starter", systemImage: "pencil") }
                    Button { navigateToDiscard = true } label: { Label("Discard helper", systemImage: "scalemass") }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(SDColor.primary)
                }
            }
        }
        .sheet(isPresented: $vm.showAddFeeding) {
            AddFeedingSheet(starter: vm.starter)
        }
        .navigationDestination(isPresented: $vm.showEdit) {
            StarterEditView(starter: vm.starter)
        }
        .navigationDestination(isPresented: $navigateToCamera) {
            AICameraView(starter: vm.starter)
        }
        .navigationDestination(isPresented: $navigateToDiscard) {
            DiscardCalculatorView(prefillCurrent: vm.starter.feedings.last?.starterGrams)
        }
        .task { await vm.refresh(services: services) }
        .refreshable { await vm.refresh(services: services) }
    }

    private var healthCard: some View {
        SDCard(variant: .elevated) {
            HStack(spacing: SDSpace.s6) {
                VStack(alignment: .leading, spacing: SDSpace.s2) {
                    Text("Health Score")
                        .font(SDFont.labelMedium)
                        .foregroundStyle(SDColor.textSecondary)
                    if let score = vm.starter.healthScore {
                        HStack(alignment: .lastTextBaseline, spacing: SDSpace.s1) {
                            Text(String(format: "%.1f", score))
                                .font(SDFont.numberLarge)
                                .foregroundStyle(SDColor.textPrimary)
                            Text("/ 10")
                                .font(SDFont.bodyLarge)
                                .foregroundStyle(SDColor.textSecondary)
                        }
                        SDProgressBar(value: score / 10, style: progressStyle(score))
                    } else {
                        Text("Not yet analyzed")
                            .font(SDFont.bodyMedium)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: SDSpace.s2) {
                    Text("\(vm.starter.ageInDays)")
                        .font(SDFont.numberMedium)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("days old")
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.textSecondary)
                }
            }
        }
        .padding(.horizontal, SDSpace.screenMargin)
    }

    private var metaRow: some View {
        HStack(spacing: SDSpace.s4) {
            metaTile(icon: SDIcon.grainFlour,  label: "Flour",    value: vm.starter.flourType.displayName)
            Divider().frame(height: 40)
            metaTile(icon: SDIcon.drop,        label: "Hydration", value: "\(vm.starter.hydration)%")
            Divider().frame(height: 40)
            metaTile(icon: SDIcon.feed,        label: "Feedings",  value: "\(vm.starter.feedings.count)")
        }
        .padding(.horizontal, SDSpace.screenMargin)
    }

    private func metaTile(icon: String, label: String, value: String) -> some View {
        VStack(spacing: SDSpace.s1) {
            Image(systemName: icon)
                .font(.system(size: SDIconSize.md))
                .foregroundStyle(SDColor.primary)
            Text(value)
                .font(SDFont.labelMedium)
                .foregroundStyle(SDColor.textPrimary)
            Text(label)
                .font(SDFont.captionSmall)
                .foregroundStyle(SDColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var feedingHistory: some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            SDSectionHeader(title: "Feeding History")
                .padding(.horizontal, SDSpace.screenMargin)

            let recentFeedings = vm.starter.feedings.sorted { $0.date > $1.date }.prefix(20)
            if recentFeedings.isEmpty {
                Text("No feedings logged yet.")
                    .font(SDFont.bodyMedium)
                    .foregroundStyle(SDColor.textSecondary)
                    .padding(.horizontal, SDSpace.screenMargin)
            } else {
                SDCard {
                    VStack(spacing: 0) {
                        ForEach(Array(recentFeedings.enumerated()), id: \.offset) { idx, feeding in
                            FeedingRow(feeding: feeding)
                            if idx < recentFeedings.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)
            }
        }
    }

    @ViewBuilder
    private var readinessCard: some View {
        let status = vm.readinessStatus
        if case .noData = status {
            // Show a prompt to start logging peaks
            SDCard {
                HStack(spacing: SDSpace.s3) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 24))
                        .foregroundStyle(SDColor.textTertiary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Track peak time")
                            .font(SDFont.labelMedium)
                            .foregroundStyle(SDColor.textPrimary)
                        Text("Log when your starter peaks after each feeding — we'll predict the best bake window.")
                            .font(SDFont.captionMedium)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        } else {
            SDCard(variant: .elevated) {
                HStack(spacing: SDSpace.s4) {
                    Image(systemName: readinessIcon(status))
                        .font(.system(size: 28))
                        .foregroundStyle(readinessColor(status))
                        .frame(width: 36)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(readinessTitle(status))
                            .font(SDFont.labelLarge)
                            .foregroundStyle(SDColor.textPrimary)
                        Text(readinessSubtitle(status))
                            .font(SDFont.captionMedium)
                            .foregroundStyle(SDColor.textSecondary)
                        if let avg = vm.averagePeakMinutes {
                            Text("Avg peak: \(avg / 60)h \(avg % 60 > 0 ? "\(avg % 60)m" : "") after feeding")
                                .font(SDFont.captionSmall)
                                .foregroundStyle(SDColor.textTertiary)
                        }
                    }
                    Spacer()
                    Circle()
                        .fill(readinessColor(status).opacity(0.15))
                        .frame(width: 12, height: 12)
                        .overlay(Circle().fill(readinessColor(status)).frame(width: 8, height: 8))
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
    }

    private func readinessIcon(_ status: ReadinessStatus) -> String {
        switch status {
        case .readyNow:   return "checkmark.circle.fill"
        case .readySoon:  return "clock.fill"
        case .pastPeak:   return "exclamationmark.triangle.fill"
        case .notFedYet:  return "drop.fill"
        case .noData:     return "clock.badge.questionmark"
        }
    }

    private func readinessColor(_ status: ReadinessStatus) -> Color {
        switch status {
        case .readyNow:   return SDColor.success
        case .readySoon:  return SDColor.info
        case .pastPeak:   return SDColor.warning
        case .notFedYet:  return SDColor.textTertiary
        case .noData:     return SDColor.textTertiary
        }
    }

    private func readinessTitle(_ status: ReadinessStatus) -> String {
        switch status {
        case .readyNow:              return "Ready to bake!"
        case .readySoon(let mins):   return "Ready in ~\(formatMins(mins))"
        case .pastPeak(let mins):    return "Peaked \(formatMins(mins)) ago"
        case .notFedYet:             return "Feed your starter first"
        case .noData:                return ""
        }
    }

    private func readinessSubtitle(_ status: ReadinessStatus) -> String {
        switch status {
        case .readyNow(let since):
            return since == 0 ? "Your starter is at or near peak activity." : "At peak for ~\(formatMins(since)) — bake soon."
        case .readySoon(let mins):
            return "Your starter should hit peak activity in about \(formatMins(mins))."
        case .pastPeak(let mins):
            return "\(formatMins(mins)) past peak. Feed now for better rise."
        case .notFedYet:
            return "Log a feeding to start tracking your bake window."
        case .noData:
            return ""
        }
    }

    private func formatMins(_ mins: Int) -> String {
        if mins < 60 { return "\(mins)m" }
        let h = mins / 60; let m = mins % 60
        return m > 0 ? "\(h)h \(m)m" : "\(h)h"
    }

    private func progressStyle(_ score: Double) -> SDProgressBar.Style {
        if score >= 8 { return .success }
        if score >= 6 { return .warning }
        return .error
    }
}

struct FeedingRow: View {
    let feeding: Feeding

    var body: some View {
        HStack(spacing: SDSpace.s3) {
            VStack(alignment: .leading, spacing: SDSpace.s1) {
                Text(feeding.date.relativeDescription)
                    .font(SDFont.labelSmall)
                    .foregroundStyle(SDColor.textPrimary)
                Text(feeding.descriptionLine)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
                if let smell = feeding.smellRating {
                    Text("\(smell.emoji) \(smell.displayName)")
                        .font(SDFont.captionSmall)
                        .foregroundStyle(SDColor.textTertiary)
                }
                if let peak = feeding.peakTimeMinutes {
                    let h = peak / 60; let m = peak % 60
                    let label = m > 0 ? "Peaked \(h)h \(m)m" : "Peaked \(h)h"
                    HStack(spacing: SDSpace.s1) {
                        Image(systemName: SDIcon.timer)
                            .font(.system(size: 11))
                        Text("\(label) after feeding")
                            .font(SDFont.captionSmall)
                    }
                    .foregroundStyle(SDColor.primary)
                }
            }
            Spacer()
            Text(feeding.ratio)
                .font(SDFont.labelSmall)
                .foregroundStyle(SDColor.primary)
                .padding(.horizontal, SDSpace.s2)
                .padding(.vertical, SDSpace.s1)
                .background(SDColor.secondary.opacity(0.5))
                .clipShape(Capsule())
        }
        .padding(.vertical, SDSpace.s3)
    }
}

#Preview {
    NavigationStack {
        StarterDetailView(starter: MockStarters.bubbles)
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
