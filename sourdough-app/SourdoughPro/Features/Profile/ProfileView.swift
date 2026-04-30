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

                // Avatar + name — centered identity block
                VStack(spacing: SDSpace.s3) {
                    SDAvatar(initials: user?.initials ?? "?", size: .xl)
                    VStack(spacing: SDSpace.s1) {
                        Text(user?.displayName ?? user?.email ?? "Baker")
                            .font(SDFont.headingMedium)
                            .foregroundStyle(SDColor.textPrimary)
                        if let email = user?.email, !email.isEmpty {
                            Text(email)
                                .font(SDFont.bodySmall)
                                .foregroundStyle(SDColor.textSecondary)
                        }
                    }
                    // Subscription badge
                    if let tier = user?.subscriptionTier, tier != .free {
                        HStack(spacing: SDSpace.s1) {
                            Image(systemName: SDIcon.sparkles)
                                .font(.system(size: 12))
                            Text(tier.displayName)
                                .font(SDFont.labelSmall)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, SDSpace.s4)
                        .padding(.vertical, SDSpace.s2)
                        .background(SDColor.accent)
                        .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, SDSpace.s6)

                // Stats row
                SDCard {
                    HStack(spacing: 0) {
                        statTile(
                            value: "\(vm.bakeCount)",
                            label: "Bakes",
                            icon: SDIcon.bread
                        )
                        Divider().frame(height: 40)
                        statTile(
                            value: "\(vm.feedingStreak)d",
                            label: "Streak",
                            icon: SDIcon.flame
                        )
                        Divider().frame(height: 40)
                        statTile(
                            value: user?.subscriptionTier == .free ? "\(user?.aiScansRemaining ?? 0)" : "∞",
                            label: "AI Scans",
                            icon: SDIcon.sparkles
                        )
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)

                // Menu
                SDCard {
                    VStack(spacing: 0) {
                        menuRow(icon: "creditcard.fill", label: "Subscription",
                                destination: AnyView(SubscriptionView()))
                        Divider()
                        menuRow(icon: SDIcon.bell, label: "Notifications",
                                destination: AnyView(SettingsView()))
                        Divider()
                        menuRow(icon: SDIcon.gear, label: "Settings",
                                destination: AnyView(SettingsView()))
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)
                .padding(.bottom, SDSpace.s8)
            }
        }
        .sdBackground()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load(services: services) }
        .refreshable { await vm.load(services: services) }
    }

    private func statTile(value: String, label: String, icon: String) -> some View {
        VStack(spacing: SDSpace.s1) {
            Image(systemName: icon)
                .font(.system(size: SDIconSize.sm))
                .foregroundStyle(SDColor.primary)
            Text(value)
                .font(SDFont.numberMedium)
                .foregroundStyle(SDColor.textPrimary)
            Text(label)
                .font(SDFont.captionSmall)
                .foregroundStyle(SDColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SDSpace.s4)
    }

    private func menuRow(icon: String, label: String, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: SDIconSize.sm))
                    .foregroundStyle(SDColor.primary)
                    .frame(width: 28)
                Text(label)
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textPrimary)
                Spacer()
                Image(systemName: SDIcon.forward)
                    .font(.system(size: 13))
                    .foregroundStyle(SDColor.textTertiary)
            }
            .padding(.vertical, SDSpace.s3)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
