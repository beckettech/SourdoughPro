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
    @State private var navigateToDiscard = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Greeting header — lightweight, recedes from focal element
                greetingHeader
                    .padding(.bottom, SDSpace.s5)

                // Feeding reminder — urgent, appears first when needed
                if let feeder = vm.upcomingFeeder {
                    FeedingReminderCard(starter: feeder) {
                        feedingTargetStarter = feeder
                        showAddFeedingSheet = true
                    }
                    .padding(.horizontal, SDSpace.screenMargin)
                    .padding(.bottom, SDSpace.s5)
                }

                // Readiness banner — THE focal element of the home screen
                if let starter = vm.selectedStarter {
                    StarterReadinessBanner(starter: starter)
                        .padding(.horizontal, SDSpace.screenMargin)
                        .padding(.bottom, SDSpace.s6)
                }

                // Starter chips
                if !vm.starters.isEmpty {
                    VStack(alignment: .leading, spacing: SDSpace.s3) {
                        HStack {
                            Text("My Starters")
                                .font(SDFont.labelMedium)
                                .foregroundStyle(SDColor.textSecondary)
                            Spacer()
                            NavigationLink("See all") {
                                StarterListView()
                            }
                            .font(SDFont.captionMedium)
                            .foregroundStyle(SDColor.textLink)
                            .padding(.horizontal, SDSpace.screenMargin)
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
                    .padding(.bottom, SDSpace.s6)
                }

                // Quick actions
                VStack(alignment: .leading, spacing: SDSpace.s3) {
                    Text("Quick Actions")
                        .font(SDFont.labelMedium)
                        .foregroundStyle(SDColor.textSecondary)
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

                            QuickActionCard(action: QuickAction(
                                icon: SDIcon.scale,
                                title: "Discard",
                                subtitle: "Calculate keep & feed",
                                action: { navigateToDiscard = true }))
                        }
                        .padding(.horizontal, SDSpace.screenMargin)
                        .padding(.vertical, SDSpace.s1)
                    }
                }
                .padding(.bottom, SDSpace.s6)

                // Recent bakes
                if !vm.recentBakes.isEmpty {
                    VStack(alignment: .leading, spacing: SDSpace.s3) {
                        Text("Recent Bakes")
                            .font(SDFont.labelMedium)
                            .foregroundStyle(SDColor.textSecondary)
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
                    .padding(.bottom, SDSpace.s4)
                }
            }
            .padding(.top, SDSpace.s5)
        }
        .sdBackground()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
        .navigationDestination(isPresented: $navigateToDiscard) {
            DiscardCalculatorView()
        }
    }

    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingText)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textTertiary)
                Text(appState.user?.displayName ?? appState.user?.email ?? "Baker")
                    .font(SDFont.headingMedium)
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
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        default:      return "Good evening"
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
