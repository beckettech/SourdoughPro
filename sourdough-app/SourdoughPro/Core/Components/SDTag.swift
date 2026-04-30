import SwiftUI

/// Read-only tag, smaller than a chip.
struct SDTag: View {
    let text: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 4) {
            if let icon { Image(systemName: icon).font(.system(size: 11)) }
            Text(text).font(SDFont.captionMedium)
        }
        .foregroundStyle(SDColor.textPrimary)
        .padding(.horizontal, SDSpace.s2)
        .frame(height: 28)
        .background(SDColor.secondaryLight)
        .overlay(
            RoundedRectangle(cornerRadius: SDRadius.xs).stroke(SDColor.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.xs))
    }
}
