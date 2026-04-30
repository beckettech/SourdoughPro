import SwiftUI

struct RecentBakeRow: View {
    let bake: BakeSession

    private var stars: Int { bake.rating ?? 0 }

    var body: some View {
        HStack(spacing: SDSpace.s4) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: SDRadius.sm)
                    .fill(SDColor.secondary.opacity(0.5))
                    .frame(width: 48, height: 48)
                Image(systemName: SDIcon.bread)
                    .font(.system(size: 22))
                    .foregroundStyle(SDColor.primary)
            }

            VStack(alignment: .leading, spacing: SDSpace.s1) {
                Text(bake.recipeName)
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textPrimary)
                    .lineLimit(1)
                if let completed = bake.completedAt {
                    Text(completed.relativeDescription)
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.textSecondary)
                }
            }

            Spacer()

            // Star rating
            if stars > 0 {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= stars ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundStyle(i <= stars ? SDColor.accent : SDColor.border)
                    }
                }
            }
        }
        .padding(.vertical, SDSpace.s3)
    }
}

#Preview {
    VStack {
        ForEach(MockBakes.recent) { bake in
            RecentBakeRow(bake: bake)
            Divider()
        }
    }
    .padding()
    .sdBackground()
}
