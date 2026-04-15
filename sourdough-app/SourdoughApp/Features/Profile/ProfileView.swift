import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var bakeCount: Int = 0
    @Published var feedingStreak: Int = 0
    @Published var isLoading = false

    func load(services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        let sessions = (try? await services.bakes.listSessions()) ?? []
        bakeCount = sessions.filter { $0.completedAt != nil }.count
        let starters = (try? await services.starters.listStarters()) ?? []
        let allFeedings = starters.flatMap { $0.feedings }
        feedingStreak = StreakCounter.currentStreak(feedings: allFeedings)
    }
}

struct ProfileView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = ProfileViewModel()

    var user: User? { appState.user }

    var body: some View {
        ScrollView {
            VStack(spacing: SDSpace.s6) {

                // Avatar + name
                VStack(spacing: SDSpace.s3) {
                    SDAvatar(initials: user?.initials ?? "?", size: .xl)
                    VStack(spacing: SDSpace.s1) {
                        Text(user?.displayName ?? user?.email ?? "Baker")
                            .font(SDFont.headingMedium)
                            .foregroundStyle(SDColor.textPrimary)
                        Text(user?.email ?? "")
                            .font(SDFont.bodySmall)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                    // Subscription badge
                    if let tier = user?.subscriptionTier, tier != .free {
                        HStack(spacing: 4) {
                            Image(systemName: SDIcon.sparkles)
                            Text(tier.displayName)
                        }
                        .font(SDFont.labelSmall)
                        .foregroundStyle(.white)
                        .padding(.horizontal, SDSpace.s4)
                        .padding(.vertical, SDSpace.s2)
                        .background(SDColor.accent)
                        .clipShape(Capsule())
                    }
                }
                .padding(.top, SDSpace.s6)

                // Stats row
                HStack(spacing: 0) {
                    statTile(value: "\(vm.bakeCount)",      label: "Bakes")
                    Divider().frame(height: 40)
                    statTile(value: "\(vm.feedingStreak)d", label: "Streak")
                    Divider().frame(height: 40)
                    statTile(value: "\(user?.aiScansRemaining ?? 0)", label: aiScansLabel)
                }
                .padding(.vertical, SDSpace.s4)
                .background(SDColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
                .sdShadow(SDShadow.card)
                .padding(.horizontal, SDSpace.screenMargin)

                // Menu
                SDCard {
                    VStack(spacing: 0) {
                        menuRow(icon: "creditcard", label: "Subscription") {
                            NavigationLink(destination: SubscriptionView()) {
                                menuRowContent(icon: "creditcard", label: "Subscription")
                            }
                            .buttonStyle(.plain)
                        }
                        Divider()
                        menuRow(icon: "bell", label: "Notifications") {
                            NavigationLink(destination: SettingsView()) {
                                menuRowContent(icon: "bell", label: "Notifications")
                            }
                            .buttonStyle(.plain)
                        }
                        Divider()
                        menuRow(icon: "gear", label: "Settings") {
                            NavigationLink(destination: SettingsView()) {
                                menuRowContent(icon: "gear", label: "Settings")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)
            }
            .padding(.bottom, SDSpace.s8)
        }
        .sdBackground()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .task { await vm.load(services: services) }
        .refreshable { await vm.load(services: services) }
    }

    private var aiScansLabel: String {
        user?.subscriptionTier == .free ? "AI Scans" : "AI: ∞"
    }

    private func statTile(value: String, label: String) -> some View {
        VStack(spacing: SDSpace.s1) {
            Text(value)
                .font(SDFont.numberMedium)
                .foregroundStyle(SDColor.textPrimary)
            Text(label)
                .font(SDFont.captionSmall)
                .foregroundStyle(SDColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func menuRow(icon: String, label: String, @ViewBuilder content: () -> some View) -> some View {
        content()
            .padding(.vertical, SDSpace.s3)
    }

    private func menuRowContent(icon: String, label: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(SDColor.primary)
                .frame(width: 28)
            Text(label)
                .font(SDFont.labelMedium)
                .foregroundStyle(SDColor.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundStyle(SDColor.textTertiary)
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
