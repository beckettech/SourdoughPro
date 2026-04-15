import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var starters: [Starter] = []
    @Published var recentBakes: [BakeSession] = []
    @Published var isLoading = false
    @Published var selectedStarterId: UUID? = nil

    var selectedStarter: Starter? {
        starters.first(where: { $0.id == selectedStarterId }) ?? starters.first
    }

    var upcomingFeeder: Starter? {
        starters
            .filter { FeedingScheduler.hoursUntilNextFeeding(for: $0) ?? Int.max < 6
                       || FeedingScheduler.isOverdue($0) }
            .sorted { (FeedingScheduler.hoursUntilNextFeeding(for: $0) ?? 99)
                       < (FeedingScheduler.hoursUntilNextFeeding(for: $1) ?? 99) }
            .first
    }

    func load(services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        async let s = try? services.starters.listStarters()
        async let b = try? services.bakes.listSessions()
        starters    = (await s)  ?? []
        recentBakes = (await b)  ?? []
        if selectedStarterId == nil { selectedStarterId = starters.first?.id }
    }
}

struct HomeView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = HomeViewModel()

    @State private var showAddFeedingSheet = false
    @State private var feedingTargetStarter: Starter? = nil
    @State private var navigateToBake = false
    @State private var navigateToCamera = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {

                // Greeting header
                greetingHeader

                // Feeding reminder
                if let feeder = vm.upcomingFeeder {
                    FeedingReminderCard(starter: feeder) {
                        feedingTargetStarter = feeder
                        showAddFeedingSheet = true
                    }
                    .padding(.horizontal, SDSpace.screenMargin)
                }

                // Starter chips
                if !vm.starters.isEmpty {
                    VStack(alignment: .leading, spacing: SDSpace.s3) {
                        SDSectionHeader(title: "My Starters") {
                            NavigationLink("See all") {
                                StarterListView()
                            }
                            .font(SDFont.labelSmall)
                            .foregroundStyle(SDColor.textLink)
                        }
                        .padding(.horizontal, SDSpace.screenMargin)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: SDSpace.s3) {
                                ForEach(vm.starters) { starter in
                                    NavigationLink(destination: StarterDetailView(starter: starter)) {
                                        StarterChipCard(
                                            starter: starter,
                                            isSelected: starter.id == vm.selectedStarterId
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .onTapGesture { vm.selectedStarterId = starter.id }
                                }
                            }
                            .padding(.horizontal, SDSpace.screenMargin)
                            .padding(.vertical, SDSpace.s1)
                        }
                    }
                }

                // Quick actions
                VStack(alignment: .leading, spacing: SDSpace.s3) {
                    SDSectionHeader(title: "Quick Actions")
                        .padding(.horizontal, SDSpace.screenMargin)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SDSpace.s3) {
                            QuickActionCard(action: QuickAction(
                                icon: SDIcon.recipe,
                                title: "New Bake",
                                subtitle: "Pick a recipe and start",
                                action: { navigateToBake = true }))

                            QuickActionCard(action: QuickAction(
                                icon: SDIcon.camera,
                                title: "AI Scan",
                                subtitle: "Check starter health",
                                action: { navigateToCamera = true }))

                            QuickActionCard(action: QuickAction(
                                icon: SDIcon.drop,
                                title: "Log Feeding",
                                subtitle: "Record your last feed",
                                action: {
                                    if let s = vm.selectedStarter {
                                        feedingTargetStarter = s
                                        showAddFeedingSheet = true
                                    }
                                }))
                        }
                        .padding(.horizontal, SDSpace.screenMargin)
                        .padding(.vertical, SDSpace.s1)
                    }
                }

                // Recent bakes
                if !vm.recentBakes.isEmpty {
                    VStack(alignment: .leading, spacing: SDSpace.s2) {
                        SDSectionHeader(title: "Recent Bakes")
                            .padding(.horizontal, SDSpace.screenMargin)

                        SDCard {
                            VStack(spacing: 0) {
                                ForEach(Array(vm.recentBakes.prefix(3).enumerated()), id: \.offset) { idx, bake in
                                    RecentBakeRow(bake: bake)
                                    if idx < min(2, vm.recentBakes.count - 1) {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, SDSpace.screenMargin)
                    }
                }
            }
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
        .refreshable { await vm.load(services: services) }
        .task { await vm.load(services: services) }
        .sheet(isPresented: $showAddFeedingSheet) {
            if let starter = feedingTargetStarter {
                AddFeedingSheet(starter: starter)
            }
        }
        .navigationDestination(isPresented: $navigateToBake) {
            RecipeLibraryView()
        }
        .navigationDestination(isPresented: $navigateToCamera) {
            AICameraView()
        }
    }

    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: SDSpace.s1) {
                Text(greetingText)
                    .font(SDFont.headingSmall)
                    .foregroundStyle(SDColor.textSecondary)
                Text(appState.user?.displayName ?? appState.user?.email ?? "Baker")
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
            }
            Spacer()
            SDAvatar(initials: appState.user?.initials ?? "B", size: .md)
        }
        .padding(.horizontal, SDSpace.screenMargin)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default:      return "Good evening,"
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
