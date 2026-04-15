import SwiftUI

@MainActor
final class StarterListViewModel: ObservableObject {
    @Published var starters: [Starter] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAddStarter = false

    func load(services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        do {
            starters = try await services.starters.listStarters()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(at offsets: IndexSet, services: ServiceContainer) {
        let ids = offsets.map { starters[$0].id }
        starters.remove(atOffsets: offsets)
        Task {
            for id in ids {
                try? await services.starters.deleteStarter(id)
            }
        }
    }
}

struct StarterListView: View {
    @Environment(\.services) private var services
    @StateObject private var vm = StarterListViewModel()

    var body: some View {
        Group {
            if vm.isLoading && vm.starters.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.starters.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .sdBackground()
        .navigationTitle("Starters")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.showAddStarter = true
                } label: {
                    Image(systemName: SDIcon.plus)
                }
                .foregroundStyle(SDColor.primary)
            }
        }
        .task { await vm.load(services: services) }
        .refreshable { await vm.load(services: services) }
        .navigationDestination(isPresented: $vm.showAddStarter) {
            CreateStarterView()
        }
    }

    private var list: some View {
        List {
            ForEach(vm.starters) { starter in
                NavigationLink(destination: StarterDetailView(starter: starter)) {
                    StarterListRow(starter: starter)
                }
                .listRowBackground(SDColor.surface)
                .listRowSeparatorTint(SDColor.border)
            }
            .onDelete { vm.delete(at: $0, services: services) }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: SDSpace.s4) {
            Spacer()
            Image(systemName: SDIcon.starterJar)
                .font(.system(size: 64))
                .foregroundStyle(SDColor.border)
            Text("No starters yet")
                .font(SDFont.headingSmall)
                .foregroundStyle(SDColor.textSecondary)
            Text("Create your first starter to begin your sourdough journey.")
                .font(SDFont.bodyMedium)
                .foregroundStyle(SDColor.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SDSpace.screenMarginLg)
            SDButton(title: "Create Starter") { vm.showAddStarter = true }
                .padding(.horizontal, SDSpace.screenMargin)
            Spacer()
        }
    }
}

struct StarterListRow: View {
    let starter: Starter

    private var healthColor: Color {
        guard let s = starter.healthScore else { return SDColor.border }
        if s >= 8 { return SDColor.success }
        if s >= 6 { return SDColor.warning }
        return SDColor.error
    }

    var body: some View {
        HStack(spacing: SDSpace.s4) {
            ZStack {
                Circle()
                    .fill(SDColor.secondary.opacity(0.5))
                    .frame(width: 44, height: 44)
                Image(systemName: SDIcon.starterJar)
                    .font(.system(size: 20))
                    .foregroundStyle(SDColor.primary)
            }

            VStack(alignment: .leading, spacing: SDSpace.s1) {
                HStack {
                    Text(starter.name)
                        .font(SDFont.labelLarge)
                        .foregroundStyle(SDColor.textPrimary)
                    Circle()
                        .fill(healthColor)
                        .frame(width: 8, height: 8)
                }
                Text(starter.flourType.displayName)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
                if let fed = starter.lastFedAt {
                    Text("Fed \(fed.relativeDescription)")
                        .font(SDFont.captionSmall)
                        .foregroundStyle(SDColor.textTertiary)
                }
            }

            Spacer()

            if let score = starter.healthScore {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.1f", score))
                        .font(SDFont.labelMedium)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("health")
                        .font(SDFont.captionSmall)
                        .foregroundStyle(SDColor.textTertiary)
                }
            }
        }
        .padding(.vertical, SDSpace.s2)
    }
}

#Preview {
    NavigationStack { StarterListView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
