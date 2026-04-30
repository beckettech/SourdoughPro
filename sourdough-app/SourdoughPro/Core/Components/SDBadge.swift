import SwiftUI

/// Numeric or dot badge per FIGMA_SPECS.md §Components > Badge.
struct SDBadge: View {
    let count: Int?
    var background: Color = SDColor.error

    var body: some View {
        Group {
            if let count, count > 0 {
                Text(count > 99 ? "99+" : "\(count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .frame(minWidth: 20, minHeight: 20)
                    .background(background)
                    .clipShape(Capsule())
            } else if count == nil {
                Circle().fill(background).frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        SDBadge(count: nil)
        SDBadge(count: 3)
        SDBadge(count: 42)
        SDBadge(count: 128)
    }.padding().background(SDColor.background)
}
