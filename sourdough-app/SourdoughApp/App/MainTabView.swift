import SwiftUI

enum MainTab: Hashable {
    case home, starters, recipes, profile
}

struct MainTabView: View {
    @State private var selection: MainTab = .home

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: SDIcon.house) }
                .tag(MainTab.home)

            NavigationStack { StarterListView() }
                .tabItem { Label("Starters", systemImage: SDIcon.starterJar) }
                .tag(MainTab.starters)

            NavigationStack { RecipeLibraryView() }
                .tabItem { Label("Recipes", systemImage: SDIcon.bookshelf) }
                .tag(MainTab.recipes)

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: SDIcon.person) }
                .tag(MainTab.profile)
        }
        .tint(SDColor.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
