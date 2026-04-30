import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Hero — clean amber, no gradient
            heroArea

            Spacer()

            // App name + tagline
            VStack(spacing: SDSpace.s2) {
                Text("SourdoughPro")
                    .font(SDFont.displayLarge)
                    .foregroundStyle(SDColor.textPrimary)
                Text("Track your starter. Bake better bread.")
                    .font(SDFont.bodyLarge)
                    .foregroundStyle(SDColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, SDSpace.screenMargin)

            Spacer()

            // CTAs
            VStack(spacing: SDSpace.s3) {
                NavigationLink(destination: SignUpView()) {
                    buttonRow(title: "Get Started", style: .primary)
                }
                .buttonStyle(.plain)

                NavigationLink(destination: SignInView()) {
                    buttonRow(title: "I have an account", style: .secondary)
                }
                .buttonStyle(.plain)

                Button {
                    appState.user = MockUser.sample
                } label: {
                    Text("Continue without account")
                        .font(SDFont.labelSmall)
                        .foregroundStyle(SDColor.textTertiary)
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.bottom, SDSpace.s12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sdBackground()
        .navigationBarBackButtonHidden()
    }

    // MARK: Hero

    private var heroArea: some View {
        ZStack {
            // Outer ambient ring
            Circle()
                .fill(SDColor.primary.opacity(0.06))
                .frame(width: 260, height: 260)
            // Inner fill circle
            Circle()
                .fill(SDColor.primary.opacity(0.10))
                .overlay(Circle().strokeBorder(SDColor.border, lineWidth: 1))
                .frame(width: 200, height: 200)
            // Bread icon
            Image(systemName: SDIcon.bread)
                .resizable().scaledToFit()
                .foregroundStyle(SDColor.primary)
                .frame(width: 96, height: 96)
        }
    }

    // MARK: Button row — matches SDButton visually but supports NavigationLink

    private func buttonRow(title: String, style: SDButton.Style) -> some View {
        HStack {
            Text(title)
                .font(SDFont.labelLarge)
                .foregroundStyle(style == .primary ? .white : SDColor.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .padding(.horizontal, SDSpace.s6)
        .background(style == .primary ? SDColor.primary : SDColor.surface)
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.md)
                .strokeBorder(style == .secondary ? SDColor.primary : .clear, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
        .sdShadow(style == .primary ? SDShadow.button : SDShadow(color: .clear, radius: 0, x: 0, y: 0))
    }
}

#Preview {
    NavigationStack { WelcomeView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
