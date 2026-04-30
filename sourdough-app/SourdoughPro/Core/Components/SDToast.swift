import SwiftUI

/// Toast / Snackbar per FIGMA_SPECS.md §Components > Toast.
struct SDToast: Identifiable, Equatable {
    enum Style { case `default`, success, warning, error }
    let id = UUID()
    let message: String
    var style: Style = .default
}

struct SDToastView: View {
    let toast: SDToast

    var body: some View {
        HStack(spacing: SDSpace.s2) {
            if let iconName {
                Image(systemName: iconName).foregroundStyle(.white)
            }
            Text(toast.message)
                .font(SDFont.bodyMedium)
                .foregroundStyle(.white)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, SDSpace.s4)
        .frame(minHeight: 48)
        .padding(.vertical, SDSpace.s2)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
        .sdShadow(SDShadow.lg)
        .padding(.horizontal, SDSpace.s4)
    }

    private var background: Color {
        switch toast.style {
        case .default: return SDColor.textPrimary
        case .success: return SDColor.success
        case .warning: return SDColor.warning
        case .error:   return SDColor.error
        }
    }

    private var iconName: String? {
        switch toast.style {
        case .default: return nil
        case .success: return SDIcon.checkmarkCircle
        case .warning: return SDIcon.warningTriangle
        case .error:   return SDIcon.errorCircle
        }
    }
}

/// ViewModifier overlay that shows toasts with auto-dismiss.
struct SDToastContainer: ViewModifier {
    @Binding var toast: SDToast?
    var duration: TimeInterval = 4

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let toast {
                    SDToastView(toast: toast)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, SDSpace.s4)
                        .task(id: toast.id) {
                            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                            withAnimation { self.toast = nil }
                        }
                }
            }
            .animation(.easeOut(duration: 0.3), value: toast?.id)
    }
}

extension View {
    func sdToast(_ toast: Binding<SDToast?>) -> some View {
        modifier(SDToastContainer(toast: toast))
    }
}
