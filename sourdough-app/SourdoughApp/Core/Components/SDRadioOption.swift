import SwiftUI

/// Radio list item per FIGMA_SPECS.md §Create Starter screen.
struct SDRadioOption<Value: Hashable>: View {
    let label: String
    var helper: String? = nil
    let value: Value
    @Binding var selection: Value

    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) {
                selection = value
            }
        } label: {
            HStack(spacing: SDSpace.s3) {
                ZStack {
                    Circle().stroke(isSelected ? SDColor.primary : SDColor.border, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle().fill(SDColor.primary).frame(width: 12, height: 12)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(label).font(SDFont.bodyLarge).foregroundStyle(SDColor.textPrimary)
                    if let helper {
                        Text(helper).font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, SDSpace.s4)
            .frame(minHeight: 56)
            .background(SDColor.surface)
            .overlay(
                RoundedRectangle(cornerRadius: SDRadius.sm)
                    .stroke(isSelected ? SDColor.primary : SDColor.border, lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.sm))
        }
        .buttonStyle(.plain)
    }

    private var isSelected: Bool { selection == value }
}
