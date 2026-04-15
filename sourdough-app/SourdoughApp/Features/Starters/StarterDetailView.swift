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
}

struct StarterDetailView: View {
    @Environment(\.services) private var services
    @StateObject private var vm: StarterDetailViewModel
    @State private var navigateToCamera = false

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
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { vm.showEdit = true }
                    .foregroundStyle(SDColor.primary)
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
