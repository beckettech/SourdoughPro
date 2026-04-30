import SwiftUI

@MainActor
final class StarterEditViewModel: ObservableObject {
    @Published var name: String
    @Published var flourType: FlourType
    @Published var hydration: String
    @Published var notes: String
    @Published var isSaving = false
    @Published var errorMessage: String? = nil
    @Published var didSave = false

    private let originalId: UUID

    init(starter: Starter) {
        self.originalId   = starter.id
        self.name         = starter.name
        self.flourType    = starter.flourType
        self.hydration    = "\(starter.hydration)"
        self.notes        = starter.notes
    }

    func save(originalStarter: Starter, services: ServiceContainer) async {
        errorMessage = nil
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Name is required."
            return
        }
        isSaving = true
        defer { isSaving = false }
        var updated       = originalStarter
        updated.name      = name.trimmingCharacters(in: .whitespaces)
        updated.flourType = flourType
        updated.hydration = Int(hydration) ?? originalStarter.hydration
        updated.notes     = notes
        do {
            _ = try await services.starters.updateStarter(updated)
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct StarterEditView: View {
    let starter: Starter
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: StarterEditViewModel

    init(starter: Starter) {
        self.starter = starter
        _vm = StateObject(wrappedValue: StarterEditViewModel(starter: starter))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {
                SDTextField(label: "Name", placeholder: "e.g., Bubbles",
                            text: $vm.name, textContentType: .none, autocapitalization: .words)

                VStack(alignment: .leading, spacing: SDSpace.s2) {
                    Text("Flour type").font(SDFont.labelMedium).foregroundStyle(SDColor.textSecondary)
                    VStack(spacing: SDSpace.s2) {
                        ForEach([FlourType.bread, .wholeWheat, .allPurpose, .rye]) { type in
                            SDRadioOption(label: type.displayName, helper: type.helper,
                                          value: type, selection: $vm.flourType)
                        }
                    }
                }

                SDTextField(label: "Hydration %", placeholder: "100",
                            text: $vm.hydration, keyboardType: .numberPad)

                SDTextField(label: "Notes", placeholder: "Any notes about your starter...",
                            text: $vm.notes)

                if let err = vm.errorMessage {
                    Text(err).font(SDFont.captionMedium).foregroundStyle(SDColor.error)
                }

                SDButton(title: "Save Changes", isLoading: vm.isSaving,
                         isEnabled: !vm.name.trimmingCharacters(in: .whitespaces).isEmpty) {
                    Task { await vm.save(originalStarter: starter, services: services) }
                }
            }
            .padding(SDSpace.screenMargin)
        }
        .sdBackground()
        .navigationTitle("Edit \(starter.name)")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: vm.didSave) { _, saved in
            if saved { dismiss() }
        }
    }
}

#Preview {
    NavigationStack {
        StarterEditView(starter: MockStarters.bubbles)
    }
    .environment(\.services, .preview())
}
