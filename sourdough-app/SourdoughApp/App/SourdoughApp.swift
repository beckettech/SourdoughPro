import SwiftUI

@main
struct SourdoughApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var services: ServiceContainer = .live(startSignedIn: false)
    @StateObject private var appState: AppState

    init() {
        let container = ServiceContainer.live(startSignedIn: false)
        _services  = StateObject(wrappedValue: container)
        _appState = StateObject(wrappedValue: AppState(services: container))
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinator()
                .environment(\.services, services)
                .environmentObject(services)
                .environmentObject(appState)
                .task {
                    // Ask once, up-front. Users can decline without blocking the flow.
                    _ = await services.notifications.requestAuthorization()
                }
        }
    }
}
