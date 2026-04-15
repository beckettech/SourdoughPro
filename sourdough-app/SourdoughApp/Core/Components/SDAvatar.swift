import SwiftUI

/// Avatar per FIGMA_SPECS.md §Components > Avatar.
struct SDAvatar: View {

    enum Size: CGFloat { case xs = 24, sm = 32, md = 40, lg = 56, xl = 80 }

    let initials: String
    var size: Size = .md
    var imageUrl: URL? = nil
    var status: Status? = nil

    enum Status { case online, offline
        var color: Color { self == .online ? SDColor.success : SDColor.textTertiary }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let imageUrl {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        default: placeholder
                        }
                    }
                } else {
                    placeholder
                }
            }
            .frame(width: size.rawValue, height: size.rawValue)
            .clipShape(Circle())

            if let status {
                Circle()
                    .fill(status.color)
                    .frame(width: indicatorSize, height: indicatorSize)
                    .overlay(Circle().stroke(SDColor.surface, lineWidth: 2))
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            SDColor.secondaryDark
            Text(initials.uppercased())
                .font(size == .xl ? SDFont.headingLarge : SDFont.headingSmall)
                .foregroundStyle(.white)
        }
    }

    private var indicatorSize: CGFloat { size.rawValue >= 56 ? 16 : 12 }
}

#Preview {
    HStack(spacing: 16) {
        SDAvatar(initials: "BE", size: .xs)
        SDAvatar(initials: "BE", size: .sm)
        SDAvatar(initials: "BE", size: .md, status: .online)
        SDAvatar(initials: "BE", size: .lg, status: .online)
        SDAvatar(initials: "BE", size: .xl)
    }.padding().background(SDColor.background)
}
