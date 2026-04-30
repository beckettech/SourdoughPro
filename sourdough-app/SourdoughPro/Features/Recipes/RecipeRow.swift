import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: SDSpace.s4) {
            // Thumbnail placeholder
            ZStack {
                RoundedRectangle(cornerRadius: SDRadius.sm)
                    .fill(SDColor.secondary.opacity(0.5))
                    .frame(width: 64, height: 64)
                Image(systemName: SDIcon.bread)
                    .font(.system(size: 28))
                    .foregroundStyle(SDColor.primary)
            }

            VStack(alignment: .leading, spacing: SDSpace.s2) {
                HStack(spacing: SDSpace.s2) {
                    Text(recipe.name)
                        .font(SDFont.labelLarge)
                        .foregroundStyle(SDColor.textPrimary)
                        .lineLimit(1)
                    if recipe.isPremium {
                        SDChip(text: "Pro", style: .warning)
                    }
                }

                Text(recipe.summary)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
                    .lineLimit(2)

                HStack(spacing: SDSpace.s3) {
                    difficultyChip
                    Label("\(recipe.totalDurationHours)h", systemImage: SDIcon.clock)
                        .font(SDFont.captionSmall)
                        .foregroundStyle(SDColor.textTertiary)
                    if let rating = recipe.rating {
                        Label(String(format: "%.1f", rating), systemImage: "star.fill")
                            .font(SDFont.captionSmall)
                            .foregroundStyle(SDColor.accent)
                    }
                }
            }
        }
        .padding(.vertical, SDSpace.s2)
    }

    private var difficultyChip: some View {
        let color: Color = {
            switch recipe.difficulty {
            case .beginner:     return SDColor.success
            case .intermediate: return SDColor.info
            case .advanced:     return SDColor.warning
            }
        }()
        return Text(recipe.difficulty.displayName)
            .font(SDFont.captionSmall)
            .foregroundStyle(color)
            .padding(.horizontal, SDSpace.s2)
            .padding(.vertical, 2)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    VStack {
        RecipeRow(recipe: MockRecipes.classicSourdough)
        RecipeRow(recipe: MockRecipes.baguette)
    }
    .padding()
    .sdBackground()
}
