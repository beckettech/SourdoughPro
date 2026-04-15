import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func signIn(services: ServiceContainer) async -> Bool {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            _ = try await services.auth.signIn(email: email, password: password)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func signInWithApple(services: ServiceContainer) async -> Bool {
        isLoading = true; defer { isLoading = false }
        do { _ = try await services.auth.signInWithApple(); return true }
        catch { errorMessage = error.localizedDescription; return false }
    }

    func signInWithGoogle(services: ServiceContainer) async -> Bool {
        isLoading = true; defer { isLoading = false }
        do { _ = try await services.auth.signInWithGoogle(); return true }
        catch { errorMessage = error.localizedDescription; return false }
    }
}

struct SignInView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = SignInViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {
                Text("Welcome back")
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .padding(.top, SDSpace.s4)

                VStack(spacing: SDSpace.s4) {
                    SDTextField(label: "Email", placeholder: "you@example.com", text: $vm.email,
                                keyboardType: .emailAddress, textContentType: .emailAddress, autocapitalization: .never)
                    SDTextField(label: "Password", placeholder: "••••••••", text: $vm.password,
                                isSecure: true, textContentType: .password)
                }

                HStack {
                    Spacer()
                    Button("Forgot password?") {
                        appState.showToast("Password reset sent (mock)", style: .success)
                    }
                    .font(SDFont.labelSmall)
                    .foregroundStyle(SDColor.textLink)
                }

                if let err = vm.errorMessage {
                    Text(err).font(SDFont.captionMedium).foregroundStyle(SDColor.error)
                }

                SDButton(title: "Sign In", isLoading: vm.isLoading, isEnabled: canSubmit) {
                    Task { _ = await vm.signIn(services: services) }
                }

                HStack {
                    Rectangle().fill(SDColor.border).frame(height: 1)
                    Text("or").font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
                        .padding(.horizontal, SDSpace.s2)
                    Rectangle().fill(SDColor.border).frame(height: 1)
                }
                .padding(.vertical, SDSpace.s2)

                SDButton(title: "Continue with Apple", icon: "apple.logo", style: .secondary) {
                    Task { _ = await vm.signInWithApple(services: services) }
                }
                SDButton(title: "Continue with Google", icon: "globe", style: .secondary) {
                    Task { _ = await vm.signInWithGoogle(services: services) }
                }

                HStack {
                    Spacer()
                    NavigationLink(destination: SignUpView()) {
                        HStack(spacing: 4) {
                            Text("Don't have an account?").foregroundStyle(SDColor.textSecondary)
                            Text("Sign Up").foregroundStyle(SDColor.textLink).bold()
                        }
                        .font(SDFont.captionMedium)
                    }
                    Spacer()
                }
                .padding(.top, SDSpace.s6)
            }
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var canSubmit: Bool {
        vm.email.contains("@") && vm.password.count >= 4
    }
}

#Preview {
    NavigationStack { SignInView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
