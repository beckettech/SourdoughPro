import Foundation
import SwiftUI
import Combine

/// Dependency container. Exposed through SwiftUI's `@Environment`.
/// In DEBUG (or with `USE_MOCK_SERVICES=1`) the mock implementations are
/// used; in release with real secrets configured the Supabase/OpenAI/RC
/// stubs would be wired in. Flip the factory to swap.
@MainActor
final class ServiceContainer: ObservableObject {

    let auth: AuthService
    let starters: StarterService
    let recipes: RecipeService
    let bakes: BakeService
    let ai: AIVisionService
    let notifications: NotificationService
    let subscriptions: SubscriptionService

    init(auth: AuthService,
         starters: StarterService,
         recipes: RecipeService,
         bakes: BakeService,
         ai: AIVisionService,
         notifications: NotificationService,
         subscriptions: SubscriptionService) {
        self.auth = auth
        self.starters = starters
        self.recipes = recipes
        self.bakes = bakes
        self.ai = ai
        self.notifications = notifications
        self.subscriptions = subscriptions
    }

    /// The default container used by the live app. Swap individual services
    /// here when wiring real backends.
    static func live(startSignedIn: Bool = false) -> ServiceContainer {
        #if USE_REAL_SERVICES
        let api = APIClient(baseURL: URL(string: "https://your-project.supabase.co")!)
        return ServiceContainer(
            auth:          SupabaseAuthService(client: api),
            starters:      SupabaseStarterService(client: api),
            recipes:       SupabaseRecipeService(client: api),
            bakes:         SupabaseBakeService(client: api),
            ai:            OpenAIVisionService(client: api),
            notifications: LocalNotificationService(),
            subscriptions: RevenueCatSubscriptionService()
        )
        #else
        return ServiceContainer(
            auth:          MockAuthService(startSignedIn: startSignedIn),
            starters:      MockStarterService(),
            recipes:       MockRecipeService(),
            bakes:         MockBakeService(),
            ai:            MockAIVisionService(),
            notifications: LocalNotificationService(),   // real — local only
            subscriptions: MockSubscriptionService(initial: .pro)
        )
        #endif
    }

    /// Preview-only container, always mocked and pre-signed-in.
    static func preview() -> ServiceContainer {
        ServiceContainer(
            auth:          MockAuthService(startSignedIn: true),
            starters:      MockStarterService(),
            recipes:       MockRecipeService(),
            bakes:         MockBakeService(),
            ai:            MockAIVisionService(),
            notifications: MockNotificationService(),
            subscriptions: MockSubscriptionService(initial: .pro)
        )
    }
}

private struct ServiceContainerKey: EnvironmentKey {
    @MainActor static var defaultValue: ServiceContainer { ServiceContainer.preview() }
}

extension EnvironmentValues {
    var services: ServiceContainer {
        get { self[ServiceContainerKey.self] }
        set { self[ServiceContainerKey.self] = newValue }
    }
}
