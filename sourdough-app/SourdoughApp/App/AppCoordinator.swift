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
