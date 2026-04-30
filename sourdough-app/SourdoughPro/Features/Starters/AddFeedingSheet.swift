import SwiftUI

@MainActor
final class AddFeedingViewModel: ObservableObject {
    @Published var starterGrams: String = "25"
    @Published var flourGrams: String = "50"
    @Published var waterGrams: String = "50"
    @Published var notes: String = ""
    @Published var smellRating: SmellRating? = nil
    @Published var bubbleSize: BubbleSize? = nil
    @Published var riseHeightText: String = ""
    /// Did the starter peak since the last feeding? If so, how many minutes after feeding?
    @Published var peakObserved: Bool = false
    @Published var peakHours: Int = 4
    @Published var peakMinutes: Int = 0
    @Published var isSaving = false
    @Published var errorMessage: String? = nil
    @Published var didSave = false

    var peakTimeMinutes: Int? {
        guard peakObserved else { return nil }
        return peakHours * 60 + peakMinutes
    }

    var ratioPreview: String {
        let s = Int(starterGrams) ?? 25
        let f = Int(flourGrams)   ?? 50
        let w = Int(waterGrams)   ?? 50
        let min = max(1, Swift.min(s, f, w))
        func r(_ v: Int) -> String {
            let ratio = Double(v) / Double(min)
            return ratio.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(ratio))" : String(format: "%.1f", ratio)
        }
        return "\(r(s)):\(r(f)):\(r(w))"
    }

    func save(starter: Starter, services: ServiceContainer) async {
        errorMessage = nil
        guard let sg = Int(starterGrams), let fg = Int(flourGrams), let wg = Int(waterGrams) else {
            errorMessage = "Please enter valid gram amounts."
            return
        }
        isSaving = true
        defer { isSaving = false }
        let feeding = Feeding(
            starterId: starter.id,
            date: Date(),
            starterGrams: sg,
            flourGrams: fg,
            waterGrams: wg,
            notes: notes.isEmpty ? nil : notes,
            riseHeightCm: Int(riseHeightText),
            peakTimeMinutes: peakTimeMinutes,
            smellRating: smellRating,
            bubbleSize: bubbleSize
        )
        do {
            _ = try await services.starters.addFeeding(feeding)
            // Reschedule the feeding reminder for this starter using its updated history
            await services.notifications.cancelFeedingReminder(starterId: starter.id)
            if let updatedStarter = try? await services.starters.getStarter(starter.id) {
                await services.notifications.scheduleFeedingReminder(for: updatedStarter)
            }
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct AddFeedingSheet: View {
    let starter: Starter
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AddFeedingViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SDSpace.s6) {
                    // Ratio preview
                    HStack {
                        Spacer()
                        VStack(spacing: SDSpace.s1) {
                            Text(vm.ratioPreview)
                                .font(SDFont.numberMedium)
                                .foregroundStyle(SDColor.primary)
                            Text("Ratio")
                                .font(SDFont.captionMedium)
                                .foregroundStyle(SDColor.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, SDSpace.s4)
                    .background(SDColor.secondaryLight)
                    .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))

                    // Gram inputs
                    VStack(alignment: .leading, spacing: SDSpace.s2) {
                        Text("Feed amounts").font(SDFont.labelMedium).foregroundStyle(SDColor.textSecondary)
                        HStack(spacing: SDSpace.s3) {
                            gramField(label: "Starter (g)", text: $vm.starterGrams)
                            gramField(label: "Flour (g)",   text: $vm.flourGrams)
                            gramField(label: "Water (g)",   text: $vm.waterGrams)
                        }
                    }

                    // Observations
                    VStack(alignment: .leading, spacing: SDSpace.s3) {
                        Text("Observations").font(SDFont.labelMedium).foregroundStyle(SDColor.textSecondary)

                        SDTextField(label: "Rise height (cm, optional)", placeholder: "e.g. 4",
                                    text: $vm.riseHeightText, keyboardType: .numberPad)

                        // Peak time tracker
                        VStack(alignment: .leading, spacing: SDSpace.s2) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Did it peak?").font(SDFont.labelSmall).foregroundStyle(SDColor.textPrimary)
                                    Text("Time from feeding to peak helps predict your next bake window.")
                                        .font(SDFont.captionSmall)
                                        .foregroundStyle(SDColor.textTertiary)
                                }
                                Spacer()
                                Toggle("", isOn: $vm.peakObserved)
                                    .labelsHidden()
                                    .tint(SDColor.primary)
                            }

                            if vm.peakObserved {
                                HStack(spacing: SDSpace.s4) {
                                    VStack(spacing: 4) {
                                        Text("Hours")
                                            .font(SDFont.captionSmall)
                                            .foregroundStyle(SDColor.textSecondary)
                                        Stepper("\(vm.peakHours)h", value: $vm.peakHours, in: 0...24)
                                            .font(SDFont.labelMedium)
                                            .fixedSize()
                                    }
                                    VStack(spacing: 4) {
                                        Text("Minutes")
                                            .font(SDFont.captionSmall)
                                            .foregroundStyle(SDColor.textSecondary)
                                        Stepper("\(vm.peakMinutes)m", value: $vm.peakMinutes, in: 0...59, step: 15)
                                            .font(SDFont.labelMedium)
                                            .fixedSize()
                                    }
                                    Spacer()
                                    Text("Peak at \(vm.peakHours)h \(vm.peakMinutes > 0 ? "\(vm.peakMinutes)m" : "")")
                                        .font(SDFont.captionMedium)
                                        .foregroundStyle(SDColor.primary)
                                }
                                .padding(SDSpace.s3)
                                .background(SDColor.primary.opacity(0.06))
                                .clipShape(RoundedRectangle(cornerRadius: SDRadius.sm))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: vm.peakObserved)

                        VStack(alignment: .leading, spacing: SDSpace.s2) {
                            Text("Smell").font(SDFont.labelSmall).foregroundStyle(SDColor.textSecondary)
                            HStack(spacing: SDSpace.s2) {
                                ForEach(SmellRating.allCases) { rating in
                                    smellChip(rating)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: SDSpace.s2) {
                            Text("Bubble size").font(SDFont.labelSmall).foregroundStyle(SDColor.textSecondary)
                            HStack(spacing: SDSpace.s2) {
                                ForEach(BubbleSize.allCases) { size in
                                    bubbleChip(size)
                                }
                            }
                        }
                    }

                    SDTextField(label: "Notes (optional)", placeholder: "Any observations...",
                                text: $vm.notes)

                    if let err = vm.errorMessage {
                        Text(err).font(SDFont.captionMedium).foregroundStyle(SDColor.error)
                    }

                    SDButton(title: "Log Feeding", isLoading: vm.isSaving) {
                        Task { await vm.save(starter: starter, services: services) }
                    }
                }
                .padding(SDSpace.screenMargin)
            }
            .sdBackground()
            .navigationTitle("Log Feeding — \(starter.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(SDColor.textSecondary)
                }
            }
            .onChange(of: vm.didSave) { _, saved in
                if saved { dismiss() }
            }
        }
    }

    private func gramField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: SDSpace.s1) {
            Text(label).font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
            TextField("0", text: text)
                .keyboardType(.numberPad)
                .font(SDFont.labelLarge)
                .multilineTextAlignment(.center)
                .padding(SDSpace.s3)
                .background(SDColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: SDRadius.sm))
                .overlay(RoundedRectangle(cornerRadius: SDRadius.sm).stroke(SDColor.border, lineWidth: 1))
        }
        .frame(maxWidth: .infinity)
    }

    private func smellChip(_ rating: SmellRating) -> some View {
        let selected = vm.smellRating == rating
        return Button {
            vm.smellRating = selected ? nil : rating
        } label: {
            HStack(spacing: 4) {
                Text(rating.emoji)
                Text(rating.displayName)
                    .font(SDFont.captionMedium)
            }
            .padding(.horizontal, SDSpace.s3)
            .padding(.vertical, SDSpace.s2)
            .background(selected ? SDColor.primary : SDColor.surface)
            .foregroundStyle(selected ? SDColor.textInverted : SDColor.textPrimary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(selected ? SDColor.primary : SDColor.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func bubbleChip(_ size: BubbleSize) -> some View {
        let selected = vm.bubbleSize == size
        return Button {
            vm.bubbleSize = selected ? nil : size
        } label: {
            Text(size.displayName)
                .font(SDFont.captionMedium)
                .padding(.horizontal, SDSpace.s3)
                .padding(.vertical, SDSpace.s2)
                .background(selected ? SDColor.primary : SDColor.surface)
                .foregroundStyle(selected ? SDColor.textInverted : SDColor.textPrimary)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(selected ? SDColor.primary : SDColor.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddFeedingSheet(starter: MockStarters.bubbles)
        .environment(\.services, .preview())
}
