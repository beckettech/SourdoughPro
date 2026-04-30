import Foundation
import SwiftUI
import Combine

/// App-wide reactive state: which user is signed in, which toast is showing,
/// whether onboarding is complete.
@MainActor
final class AppState: ObservableObject {
    @Published var user: User? = nil
    @Published var hasCompletedOnboarding: Bool
    @Published var toast: SDToast? = nil

    private var cancellables = Set<AnyCancellable>()

    init(services: ServiceContainer) {
        self.hasCompletedOnboarding = UserDefaultsManager.shared.bool(.hasCompletedOnboarding)
        services.auth.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.user = $0 }
            .store(in: &cancellables)
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaultsManager.shared.set(true, for: .hasCompletedOnboarding)
    }

    func showToast(_ message: String, style: SDToast.Style = .default) {
        toast = SDToast(message: message, style: style)
    }
}
