import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject private var appState: AppState
    @State private var navigateToBake = false
    @State private var scaleFactor: Double = 1.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {

                // Hero banner
                heroBanner

                // Meta info row
                metaRow

                // Start Baking CTA
                SDButton(title: "Start Baking", icon: SDIcon.timer) {
                    if recipe.isPremium && appState.user?.subscriptionTier == .free {
                        appState.showToast("This recipe requires Pro. Upgrade to unlock.", style: .warning)
                    } else {
                        navigateToBake = true
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)

                // Ingredients
                ingredientsSection

                // Steps
                stepsSection

                // Tags
                if !recipe.tags.isEmpty {
                    FlowLayout(spacing: SDSpace.s2) {
                        ForEach(recipe.tags, id: \.self) { tag in
                            SDChip(text: "#\(tag)")
                        }
                    }
                    .padding(.horizontal, SDSpace.screenMargin)
                }
            }
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $navigateToBake) {
            BakeSessionView(recipe: recipe)
        }
    }

    private var heroBanner: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [SDColor.secondary, SDColor.accent.opacity(0.3)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 160)
            Image(systemName: SDIcon.bread)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(SDColor.primary.opacity(0.6))
        }
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
        .padding(.horizontal, SDSpace.screenMargin)
    }

    private var metaRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SDSpace.s4) {
                metaTile(icon: SDIcon.clock,   label: "Total",  value: "\(recipe.totalDurationHours)h")
                metaTile(icon: "timer",        label: "Active", value: "\(recipe.prepTimeMinutes)m")
                metaTile(icon: SDIcon.drop,    label: "Hydration", value: "\(recipe.hydration)%")
                metaTile(icon: "person.2",     label: "Serves", value: "\(recipe.servings)")
                if let rating = recipe.rating {
                    metaTile(icon: "star.fill", label: "Rating", value: String(format: "%.1f", rating))
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
    }

    private func metaTile(icon: String, label: String, value: String) -> some View {
        VStack(spacing: SDSpace.s1) {
            Image(systemName: icon)
                .font(.system(size: SDIconSize.sm))
                .foregroundStyle(SDColor.primary)
            Text(value)
                .font(SDFont.labelMedium)
                .foregroundStyle(SDColor.textPrimary)
            Text(label)
                .font(SDFont.captionSmall)
                .foregroundStyle(SDColor.textSecondary)
        }
        .padding(SDSpace.s3)
        .background(SDColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
        .sdShadow(SDShadow.sm)
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            HStack {
                SDSectionHeader(title: "Ingredients")
                Spacer()
                // Scale stepper
                HStack(spacing: SDSpace.s2) {
                    Button { scaleFactor = max(0.5, scaleFactor - 0.5) } label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(SDColor.primary)
                    }
                    Text(scaleFactor == 1.0 ? "1×" : String(format: "%.1f×", scaleFactor))
                        .font(SDFont.labelSmall)
                        .foregroundStyle(SDColor.textPrimary)
                        .frame(minWidth: 32)
                    Button { scaleFactor = min(4.0, scaleFactor + 0.5) } label: {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(SDColor.primary)
                    }
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)

            SDCard {
                VStack(spacing: 0) {
                    ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { idx, ing in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ing.name)
                                    .font(SDFont.labelMedium)
                                    .foregroundStyle(SDColor.textPrimary)
                                if let notes = ing.notes {
                                    Text(notes)
                                        .font(SDFont.captionSmall)
                                        .foregroundStyle(SDColor.textSecondary)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(Int((Double(ing.grams) * scaleFactor).rounded()))g")
                                    .font(SDFont.labelMedium)
                                    .foregroundStyle(SDColor.textPrimary)
                                if let pct = ing.bakersPercent {
                                    Text("\(Int(pct))%")
                                        .font(SDFont.captionSmall)
                                        .foregroundStyle(SDColor.textSecondary)
                                }
                            }
                        }
                        .padding(.vertical, SDSpace.s3)
                        if idx < recipe.ingredients.count - 1 { Divider() }
                    }
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: SDSpace.s3) {
            SDSectionHeader(title: "Steps (\(recipe.steps.count))")
                .padding(.horizontal, SDSpace.screenMargin)

            VStack(spacing: SDSpace.s3) {
                ForEach(recipe.steps) { step in
                    stepCard(step)
                }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
    }

    private func stepCard(_ step: RecipeStep) -> some View {
        HStack(alignment: .top, spacing: SDSpace.s4) {
            // Step number badge
            ZStack {
                Circle()
                    .fill(SDColor.primary)
                    .frame(width: 32, height: 32)
                Text("\(step.order)")
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textInverted)
            }

            VStack(alignment: .leading, spacing: SDSpace.s2) {
                HStack {
                    Text(step.title)
                        .font(SDFont.labelLarge)
                        .foregroundStyle(SDColor.textPrimary)
                    Spacer()
                    if let dur = step.durationMinutes {
                        Label(formatDuration(dur), systemImage: SDIcon.clock)
                            .font(SDFont.captionSmall)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                }
                Text(step.instructions)
                    .font(SDFont.bodySmall)
                    .foregroundStyle(SDColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(SDSpace.s4)
        .background(SDColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
        .sdShadow(SDShadow.sm)
    }

    private func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        let h = minutes / 60
        let m = minutes % 60
        return m == 0 ? "\(h)h" : "\(h)h \(m)m"
    }
}

/// Simple flowing layout for tags.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0, maxY: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 { y += rowHeight + spacing; x = 0; rowHeight = 0 }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxY = y + rowHeight
        }
        return CGSize(width: width, height: maxY)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX { y += rowHeight + spacing; x = bounds.minX; rowHeight = 0 }
            view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: MockRecipes.classicSourdough)
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
