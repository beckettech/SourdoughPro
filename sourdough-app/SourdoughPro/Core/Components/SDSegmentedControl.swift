import SwiftUI

/// Segmented control matching the AI Vision screen (light-on-dark) by default;
/// a `light` variant exists for light-background surfaces.
struct SDSegmentedControl<Value: Hashable>: View {

    enum Variant { case onDark, onLight }

    let options: [(label: String, value: Value)]
    @Binding var selection: Value
    var variant: Variant = .onLight

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, opt in
                let selected = opt.value == selection
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        selection = opt.value
                    }
                } label: {
                    Text(opt.label)
                        .font(SDFont.labelMedium)
                        .foregroundStyle(foregroundColor(selected: selected))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(selected ? selectedBackground : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: SDRadius.sm - 2))
                }
            }
        }
        .padding(4)
        .background(trackBackground)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.sm))
    }

    private var trackBackground: Color {
        variant == .onDark ? Color.white.opacity(0.1) : SDColor.secondary
    }
    private var selectedBackground: Color {
        variant == .onDark ? SDColor.surface : SDColor.surface
    }
    private func foregroundColor(selected: Bool) -> Color {
        if selected { return SDColor.textPrimary }
        return variant == .onDark ? .white : SDColor.textSecondary
    }
}

#Preview {
    struct Demo: View {
        @State var selection: String = "Starter"
        var body: some View {
            VStack(spacing: 24) {
                SDSegmentedControl(options: [("Starter", "Starter"), ("Crumb", "Crumb"), ("Proof", "Proof")],
                                   selection: $selection, variant: .onLight)
                SDSegmentedControl(options: [("Starter", "Starter"), ("Crumb", "Crumb"), ("Proof", "Proof")],
                                   selection: $selection, variant: .onDark)
                    .padding()
                    .background(Color.black)
            }.padding().background(SDColor.background)
        }
    }
    return Demo()
}
