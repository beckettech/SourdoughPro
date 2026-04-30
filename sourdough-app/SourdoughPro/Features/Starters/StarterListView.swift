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
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.starters) { starter in
                    NavigationLink(destination: StarterDetailView(starter: starter)) {
                        StarterListRow(starter: starter)
                            .padding(.horizontal, SDSpace.screenMargin)
                    }
                    .buttonStyle(.plain)
                    if starter.id != vm.starters.last?.id {
                        Divider()
                            .padding(.leading, SDSpace.screenMargin + 44 + SDSpace.s4)
                    }
                }
            }
            .background(SDColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.vertical, SDSpace.s3)
        }
    }

    private var emptyState: some View {
        VStack(spacing: SDSpace.s4) {
            Spacer()
            ZStack {
                Circle()
                    .fill(SDColor.primary.opacity(0.08))
                    .frame(width: 96, height: 96)
                Image(systemName: SDIcon.starterJar)
                    .font(.system(size: 44))
                    .foregroundStyle(SDColor.primary.opacity(0.5))
            }
            Text("No starters yet")
                .font(SDFont.headingSmall)
                .foregroundStyle(SDColor.textPrimary)
            Text("Name it, feed it, watch it thrive.")
                .font(SDFont.bodyMedium)
                .foregroundStyle(SDColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SDSpace.screenMarginLg)
            SDButton(title: "Create Your First Starter", icon: SDIcon.plus) {
                vm.showAddStarter = true
            }
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
            // Health-colored icon
            ZStack {
                Circle()
                    .fill(healthColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: SDIcon.starterJar)
                    .font(.system(size: 20))
                    .foregroundStyle(healthColor)
            }

            VStack(alignment: .leading, spacing: SDSpace.s1) {
                Text(starter.name)
                    .font(SDFont.labelLarge)
                    .foregroundStyle(SDColor.textPrimary)
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
                        .font(SDFont.numberMedium)
                        .foregroundStyle(healthColor)
                    Text("/ 10")
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
