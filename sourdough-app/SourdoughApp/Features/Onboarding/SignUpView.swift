import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var didSignUp: Bool = false

    func signUp(services: ServiceContainer) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            _ = try await services.auth.signUp(email: email, password: password, displayName: displayName.isEmpty ? nil : displayName)
            didSignUp = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct SignUpView: View {
    @Environment(\.services) private var services
    @StateObject private var vm = SignUpViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {
                Text("Create your account")
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .padding(.top, SDSpace.s4)

                VStack(spacing: SDSpace.s4) {
                    SDTextField(label: "Display name (optional)", placeholder: "Beck", text: $vm.displayName,
                                textContentType: .name, autocapitalization: .words)
                    SDTextField(label: "Email", placeholder: "you@example.com", text: $vm.email,
                                keyboardType: .emailAddress, textContentType: .emailAddress, autocapitalization: .never)
                    SDTextField(label: "Password", placeholder: "At least 8 characters", text: $vm.password,
                                helper: "Use a mix of letters, numbers, and symbols.",
                                isSecure: true, textContentType: .newPassword)
                }

                if let err = vm.errorMessage {
                    Text(err).font(SDFont.captionMedium).foregroundStyle(SDColor.error)
                }

                SDButton(title: "Create Account", isLoading: vm.isLoading, isEnabled: canSubmit) {
                    Task { await vm.signUp(services: services) }
                }

                Text("By continuing you agree to the Terms of Service and Privacy Policy.")
                    .font(SDFont.captionSmall)
                    .foregroundStyle(SDColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, SDSpace.s2)
            }
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $vm.didSignUp) {
            CreateStarterView()
        }
    }

    private var canSubmit: Bool {
        vm.email.contains("@") && vm.password.count >= 8
    }
}

#Preview {
    NavigationStack { SignUpView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
