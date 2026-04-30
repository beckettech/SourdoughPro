import SwiftUI

/// Top-level navigation switch. Decides whether to show the onboarding flow
/// or the main tab bar based on auth state.
struct AppCoordinator: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.services) private var services

    var body: some View {
        Group {
            if appState.user == nil {
                OnboardingFlow()
            } else {
                MainTabView()
            }
        }
        .sdToast($appState.toast)
        .preferredColorScheme(colorScheme)
        .task(id: appState.user?.id) {
            guard appState.user != nil else { return }
            // Request permission (no-op if already granted/denied)
            _ = await services.notifications.requestAuthorization()
            // Refresh all feeding reminders
            if let starters = try? await services.starters.listStarters() {
                for starter in starters {
                    await services.notifications.cancelFeedingReminder(starterId: starter.id)
                    await services.notifications.scheduleFeedingReminder(for: starter)
                }
            }
        }
    }

    private var colorScheme: ColorScheme? {
        switch appState.user?.settings.theme ?? .system {
        case .light: return .light
        case .dark:  return .dark
        case .system: return nil
        }
    }
}

struct OnboardingFlow: View {
    var body: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}
