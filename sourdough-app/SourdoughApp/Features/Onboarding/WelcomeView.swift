import SwiftUI

struct WelcomeView: View {
    @State private var signInPath = NavigationPath()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Hero illustration — composed from SF Symbols since no art is
            // bundled yet. Replace with a real asset later.
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [SDColor.secondary, SDColor.accent.opacity(0.5)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 280, height: 280)
                Image(systemName: SDIcon.bread)
                    .resizable().scaledToFit()
                    .foregroundStyle(SDColor.primary)
                    .frame(width: 120, height: 120)
                Image(systemName: SDIcon.stars)
                    .foregroundStyle(SDColor.accent)
                    .font(.system(size: 40))
                    .offset(x: 90, y: -90)
            }

            Spacer()

            VStack(spacing: SDSpace.s2) {
                Text("Master Sourdough")
                    .font(SDFont.displayMedium)
                    .foregroundStyle(SDColor.textPrimary)
                Text("Track, bake, improve")
                    .font(SDFont.bodyLarge)
                    .foregroundStyle(SDColor.textSecondary)
            }

            Spacer()

            VStack(spacing: SDSpace.s2) {
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Get Started")
                        .font(SDFont.labelLarge)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(SDColor.primary)
                        .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
                        .sdShadow(SDShadow.button)
                }
                NavigationLink {
                    SignInView()
                } label: {
                    Text("I have an account")
                        .font(SDFont.labelLarge)
                        .foregroundStyle(SDColor.primary)
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
}

#Preview {
    NavigationStack { WelcomeView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
