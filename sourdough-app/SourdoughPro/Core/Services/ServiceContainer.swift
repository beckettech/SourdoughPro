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
    ///
    /// AI Vision auto-upgrades: if `OPENAI_API_KEY` is set in Xcode build settings
    /// (and therefore present in Info.plist as `OpenAIAPIKey`), the real GPT-4o
    /// Vision service is used. Otherwise falls back to the 2-second mock.
    static func live(startSignedIn: Bool = false) -> ServiceContainer {
        #if USE_REAL_SERVICES
        let api = APIClient(baseURL: URL(string: "https://your-project.supabase.co")!)
        return ServiceContainer(
            auth:          SupabaseAuthService(client: api),
            starters:      SupabaseStarterService(client: api),
            recipes:       SupabaseRecipeService(client: api),
            bakes:         SupabaseBakeService(client: api),
            ai:            Self.makeAIService(),
            notifications: LocalNotificationService(),
            subscriptions: RevenueCatSubscriptionService()
        )
        #else
        return ServiceContainer(
            auth:          MockAuthService(startSignedIn: startSignedIn),
            starters:      MockStarterService(),
            recipes:       MockRecipeService(),
            bakes:         MockBakeService(),
            ai:            Self.makeAIService(),
            notifications: LocalNotificationService(),   // real — local only
            subscriptions: MockSubscriptionService(initial: .pro)
        )
        #endif
    }

    /// Returns `OpenAIVisionService` when the key is configured, `MockAIVisionService` otherwise.
    /// Set `OPENAI_API_KEY` in Xcode › Project › Build Settings › User-Defined.
    private static func makeAIService() -> AIVisionService {
        if let key = Bundle.main.infoDictionary?["OpenAIAPIKey"] as? String, !key.isEmpty {
            return OpenAIVisionService(apiKey: key)
        }
        return MockAIVisionService()
    }

    /// Preview-only container, always mocked and pre-signed-in.
    /// Persistence is disabled so SwiftUI previews don't write to the user's documents dir.
    static func preview() -> ServiceContainer {
        ServiceContainer(
            auth:          MockAuthService(startSignedIn: true),
            starters:      MockStarterService(persisted: false),
            recipes:       MockRecipeService(),
            bakes:         MockBakeService(persisted: false),
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
