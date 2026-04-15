import SwiftUI

@MainActor
final class CreateStarterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var flourType: FlourType = .bread
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    @Published var didCreate: Bool = false

    func save(services: ServiceContainer) async {
        errorMessage = nil
        isSaving = true
        defer { isSaving = false }
        let starter = Starter(
            name: name.trimmingCharacters(in: .whitespaces),
            createdAt: Date(),
            flourType: flourType
        )
        do {
            _ = try await services.starters.createStarter(starter)
            didCreate = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct CreateStarterView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = CreateStarterViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {
                VStack(alignment: .leading, spacing: SDSpace.s2) {
                    Text("Name Your Starter").font(SDFont.displaySmall)
                    Text("Every journey starts with your first starter.")
                        .font(SDFont.bodyLarge).foregroundStyle(SDColor.textSecondary)
                }
                .padding(.top, SDSpace.s4)

                SDTextField(label: "Name", placeholder: "e.g., Bubbles, Bread Pitt", text: $vm.name,
                            helper: "Pick anything — you can rename later.",
                            textContentType: .none, autocapitalization: .words)

                VStack(alignment: .leading, spacing: SDSpace.s2) {
                    Text("Flour type").font(SDFont.labelMedium).foregroundStyle(SDColor.textSecondary)
                    VStack(spacing: SDSpace.s2) {
                        ForEach([FlourType.bread, .wholeWheat, .allPurpose, .rye]) { type in
                            SDRadioOption(label: type.displayName, helper: type.helper,
                                          value: type, selection: $vm.flourType)
                        }
                    }
                }

                if let err = vm.errorMessage {
                    Text(err).font(SDFont.captionMedium).foregroundStyle(SDColor.error)
                }

                SDButton(title: "Create Starter",
                         isLoading: vm.isSaving,
                         isEnabled: !vm.name.trimmingCharacters(in: .whitespaces).isEmpty) {
                    Task { await vm.save(services: services) }
                }
                .padding(.top, SDSpace.s4)
            }
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle("Create Starter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skip") { appState.completeOnboarding() }
                    .foregroundStyle(SDColor.primary)
            }
        }
        .navigationDestination(isPresented: $vm.didCreate) {
            StarterGuideView()
        }
    }
}

#Preview {
    NavigationStack { CreateStarterView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
