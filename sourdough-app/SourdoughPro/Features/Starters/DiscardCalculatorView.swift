import SwiftUI

/// Helps the user figure out how much starter to discard, then how to refresh
/// what they keep at a chosen feed ratio. Solves the most-asked sourdough Q:
/// "I have Xg of starter, what do I do?"
@MainActor
final class DiscardCalculatorViewModel: ObservableObject {
    @Published var currentGramsText: String = "100"
    @Published var keepGramsText: String = "25"
    @Published var ratio: FeedRatio = .oneToTwoToTwo

    enum FeedRatio: String, CaseIterable, Identifiable {
        case oneToOneToOne   = "1:1:1"
        case oneToTwoToTwo   = "1:2:2"
        case oneToFiveToFive = "1:5:5"
        var id: String { rawValue }
        /// (flour multiplier, water multiplier) — relative to starter weight
        var multipliers: (flour: Double, water: Double) {
            switch self {
            case .oneToOneToOne:   return (1, 1)
            case .oneToTwoToTwo:   return (2, 2)
            case .oneToFiveToFive: return (5, 5)
            }
        }
        var subtitle: String {
            switch self {
            case .oneToOneToOne:   return "Daily / quick refresh"
            case .oneToTwoToTwo:   return "Standard maintenance"
            case .oneToFiveToFive: return "Long fermentation, vacation feed"
            }
        }
    }

    var current: Int { Int(currentGramsText) ?? 0 }
    var keep: Int    { Int(keepGramsText) ?? 0 }

    var discardGrams: Int { max(0, current - keep) }
    var flourGrams:   Int { Int(Double(keep) * ratio.multipliers.flour) }
    var waterGrams:   Int { Int(Double(keep) * ratio.multipliers.water) }
    var totalAfterFeed: Int { keep + flourGrams + waterGrams }

    var validation: String? {
        if current <= 0 { return "Enter your current starter weight." }
        if keep <= 0    { return "Choose how much to keep." }
        if keep > current { return "You can't keep more than you have. Lower the keep amount or feed more." }
        return nil
    }
}

struct DiscardCalculatorView: View {
    @StateObject private var vm = DiscardCalculatorViewModel()
    @Environment(\.dismiss) private var dismiss

    /// Optional pre-fill — when the calc is opened from a Starter detail screen.
    init(prefillCurrent: Int? = nil) {
        let vm = DiscardCalculatorViewModel()
        if let c = prefillCurrent { vm.currentGramsText = "\(c)" }
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {

                // Intro
                VStack(alignment: .leading, spacing: SDSpace.s2) {
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(SDColor.primary)
                    Text("Discard Helper")
                        .font(SDFont.headingMedium)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("Figure out how much to discard, what to keep, and how to refresh it.")
                        .font(SDFont.bodyMedium)
                        .foregroundStyle(SDColor.textSecondary)
                }

                // Inputs
                SDCard {
                    VStack(alignment: .leading, spacing: SDSpace.s4) {
                        SDTextField(label: "Current starter (g)", placeholder: "100",
                                    text: $vm.currentGramsText, keyboardType: .numberPad)
                        SDTextField(label: "Keep (g)", placeholder: "25",
                                    text: $vm.keepGramsText, keyboardType: .numberPad)

                        VStack(alignment: .leading, spacing: SDSpace.s2) {
                            Text("Feed ratio")
                                .font(SDFont.labelMedium)
                                .foregroundStyle(SDColor.textSecondary)
                            HStack(spacing: SDSpace.s2) {
                                ForEach(DiscardCalculatorViewModel.FeedRatio.allCases) { r in
                                    ratioChip(r)
                                }
                            }
                            Text(vm.ratio.subtitle)
                                .font(SDFont.captionSmall)
                                .foregroundStyle(SDColor.textTertiary)
                        }
                    }
                }

                // Validation message
                if let err = vm.validation {
                    Text(err)
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.warning)
                } else {
                    // Result summary
                    SDCard(variant: .elevated) {
                        VStack(spacing: SDSpace.s4) {
                            HStack(spacing: SDSpace.s4) {
                                resultTile(
                                    icon: "arrow.down.right.circle.fill",
                                    color: SDColor.warning,
                                    value: "\(vm.discardGrams)g",
                                    label: "Discard"
                                )
                                Divider().frame(height: 56)
                                resultTile(
                                    icon: "checkmark.circle.fill",
                                    color: SDColor.success,
                                    value: "\(vm.keep)g",
                                    label: "Keep"
                                )
                            }
                            Divider()
                            VStack(alignment: .leading, spacing: SDSpace.s2) {
                                Text("Refresh recipe")
                                    .font(SDFont.labelMedium)
                                    .foregroundStyle(SDColor.textSecondary)
                                feedLine(label: "Starter",  grams: vm.keep)
                                feedLine(label: "+ Flour",  grams: vm.flourGrams)
                                feedLine(label: "+ Water",  grams: vm.waterGrams)
                                Divider().padding(.vertical, 2)
                                feedLine(label: "Total after feed", grams: vm.totalAfterFeed,
                                         emphasized: true)
                            }
                        }
                    }
                }

                // Discard ideas
                VStack(alignment: .leading, spacing: SDSpace.s3) {
                    Text("What to do with discard")
                        .font(SDFont.labelMedium)
                        .foregroundStyle(SDColor.textSecondary)
                    SDCard {
                        VStack(spacing: 0) {
                            discardIdea(emoji: "🥞", title: "Sourdough pancakes",
                                        subtitle: "Mix discard with milk, egg & sugar — fluffy & tangy.")
                            Divider()
                            discardIdea(emoji: "🍪", title: "Discard crackers",
                                        subtitle: "Flatten thin, brush oil & salt, bake at 175°C / 350°F.")
                            Divider()
                            discardIdea(emoji: "🧇", title: "Sourdough waffles",
                                        subtitle: "Overnight rise → crisp, lacy waffles.")
                            Divider()
                            discardIdea(emoji: "🍞", title: "Quick discard bread",
                                        subtitle: "Rapid loaf with commercial yeast as a backup.")
                        }
                    }
                }
            }
            .padding(SDSpace.screenMargin)
        }
        .sdBackground()
        .navigationTitle("Discard Helper")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Subviews

    private func ratioChip(_ r: DiscardCalculatorViewModel.FeedRatio) -> some View {
        let selected = vm.ratio == r
        return Button {
            vm.ratio = r
        } label: {
            Text(r.rawValue)
                .font(SDFont.labelMedium)
                .foregroundStyle(selected ? SDColor.textInverted : SDColor.textPrimary)
                .padding(.horizontal, SDSpace.s4)
                .padding(.vertical, SDSpace.s2)
                .background(selected ? SDColor.primary : SDColor.surface)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(selected ? SDColor.primary : SDColor.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func resultTile(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: SDSpace.s1) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            Text(value)
                .font(SDFont.numberMedium)
                .foregroundStyle(SDColor.textPrimary)
            Text(label)
                .font(SDFont.captionSmall)
                .foregroundStyle(SDColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func feedLine(label: String, grams: Int, emphasized: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(emphasized ? SDFont.labelMedium : SDFont.captionMedium)
                .foregroundStyle(emphasized ? SDColor.textPrimary : SDColor.textSecondary)
            Spacer()
            Text("\(grams)g")
                .font(emphasized ? SDFont.labelMedium : SDFont.captionMedium)
                .foregroundStyle(emphasized ? SDColor.primary : SDColor.textPrimary)
        }
    }

    private func discardIdea(emoji: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: SDSpace.s3) {
            Text(emoji).font(.system(size: 28))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textPrimary)
                Text(subtitle)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
            }
            Spacer()
        }
        .padding(.vertical, SDSpace.s3)
    }
}

#Preview {
    NavigationStack { DiscardCalculatorView(prefillCurrent: 100) }
        .environment(\.services, .preview())
}
