import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var unitsSystem: UnitsSystem = .metric
    @Published var theme: AppTheme = .system
    @Published var notificationsEnabled: Bool = true
    @Published var feedingLeadHours: Int = 2
    @Published var isSaving = false

    func load(user: User?) {
        guard let settings = user?.settings else { return }
        unitsSystem           = settings.unitsSystem
        theme                 = settings.theme
        notificationsEnabled  = settings.notificationsEnabled
        feedingLeadHours      = settings.feedingReminderLeadTimeHours
    }

    func save(services: ServiceContainer) async {
        // In a real app: persist to Supabase / UserDefaults
        // For now the settings live in memory via mock auth
    }
}

struct SettingsView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        List {
            // Appearance
            Section("Appearance") {
                Picker("Theme", selection: $vm.theme) {
                    ForEach(AppTheme.allCases, id: \.self) { t in
                        Text(t.displayName).tag(t)
                    }
                }
            }

            // Units
            Section("Measurements") {
                Picker("Units", selection: $vm.unitsSystem) {
                    ForEach(UnitsSystem.allCases, id: \.self) { u in
                        Text(u.displayName).tag(u)
                    }
                }
            }

            // Notifications
            Section("Notifications") {
                Toggle("Feeding Reminders", isOn: $vm.notificationsEnabled)
                    .tint(SDColor.primary)
                if vm.notificationsEnabled {
                    Stepper("Lead time: \(vm.feedingLeadHours)h",
                            value: $vm.feedingLeadHours, in: 1...12)
                }
            }

            // Account
            Section("Account") {
                if let email = appState.user?.email {
                    LabeledContent("Email", value: email)
                }
                Button("Change Password") {
                    appState.showToast("Password reset email sent.", style: .success)
                }
                .foregroundStyle(SDColor.textLink)

                Button(role: .destructive) {
                    Task { try? await services.auth.signOut() }
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }

            // About
            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                Link("Privacy Policy",
                     destination: URL(string: "https://example.com/privacy")!)
                    .foregroundStyle(SDColor.textLink)
                Link("Terms of Service",
                     destination: URL(string: "https://example.com/terms")!)
                    .foregroundStyle(SDColor.textLink)
                Button("Send Feedback") {
                    appState.showToast("Thanks for your feedback!", style: .success)
                }
                .foregroundStyle(SDColor.textLink)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .sdBackground()
        .navigationTitle("Settings")
        .onAppear { vm.load(user: appState.user) }
    }
}

#Preview {
    NavigationStack { SettingsView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
