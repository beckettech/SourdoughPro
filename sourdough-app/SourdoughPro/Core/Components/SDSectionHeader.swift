import SwiftUI

/// Reusable section header: uppercase label + optional trailing content.
struct SDSectionHeader<Trailing: View>: View {
    let title: String
    @ViewBuilder let trailing: () -> Trailing

    init(title: String, @ViewBuilder trailing: @escaping () -> Trailing) {
        self.title    = title
        self.trailing = trailing
    }

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(SDFont.labelMedium)
                .foregroundStyle(SDColor.textSecondary)
                .tracking(0.5)
            Spacer()
            trailing()
        }
    }
}

extension SDSectionHeader where Trailing == EmptyView {
    init(title: String) {
        self.title    = title
        self.trailing = { EmptyView() }
    }
}

#Preview {
    VStack {
        SDSectionHeader(title: "My Starters") {
            Button("See all") {}.font(SDFont.labelSmall).foregroundStyle(SDColor.textLink)
        }
        SDSectionHeader(title: "Recent Bakes")
    }
    .padding()
    .sdBackground()
}
