import SwiftUI

/// Text input per FIGMA_SPECS.md §Components > Input.
struct SDTextField: View {

    let label: String?
    let placeholder: String
    @Binding var text: String
    var helper: String? = nil
    var error: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .sentences
    var trailingIcon: String? = nil
    var onTrailingTap: (() -> Void)? = nil
    var autocorrectionDisabled: Bool = false
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil

    @FocusState private var isFocused: Bool
    @State private var secureVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: SDSpace.s1) {
            if let label {
                Text(label)
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textSecondary)
            }
            HStack(spacing: SDSpace.s2) {
                inputField
                if isSecure {
                    Button { secureVisible.toggle() } label: {
                        Image(systemName: secureVisible ? SDIcon.eyeSlash : SDIcon.eye)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                } else if let trailingIcon {
                    Button { onTrailingTap?() } label: {
                        Image(systemName: trailingIcon)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                }
            }
            .padding(.horizontal, SDSpace.s4)
            .frame(height: 56)
            .background(SDColor.surface)
            .overlay(
                RoundedRectangle(cornerRadius: SDRadius.sm)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.sm))
            if let error {
                Text(error).font(SDFont.captionMedium).foregroundStyle(SDColor.error)
            } else if let helper {
                Text(helper).font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
            }
        }
    }

    @ViewBuilder
    private var inputField: some View {
        Group {
            if isSecure && !secureVisible {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .font(SDFont.bodyLarge)
        .foregroundStyle(SDColor.textPrimary)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .textInputAutocapitalization(autocapitalization)
        .autocorrectionDisabled(autocorrectionDisabled)
        .submitLabel(submitLabel)
        .onSubmit { onSubmit?() }
        .focused($isFocused)
    }

    private var borderColor: Color {
        if error != nil { return SDColor.error }
        if isFocused    { return SDColor.primary }
        return SDColor.border
    }
}

#Preview("SDTextField") {
    struct Demo: View {
        @State var email = ""
        @State var pw = ""
        var body: some View {
            VStack(spacing: 16) {
                SDTextField(label: "Email", placeholder: "you@example.com", text: $email, keyboardType: .emailAddress, autocapitalization: .never)
                SDTextField(label: "Password", placeholder: "••••••••", text: $pw, isSecure: true)
                SDTextField(label: "With error", placeholder: "Name", text: .constant(""), error: "Required")
            }.padding().background(SDColor.background)
        }
    }
    return Demo()
}
