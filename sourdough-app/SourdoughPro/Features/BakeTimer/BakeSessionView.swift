import SwiftUI
import Combine

@MainActor
final class BakeSessionViewModel: ObservableObject {
    @Published var session: BakeSession? = nil
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var timerRunning = false
    @Published var secondsRemaining = 0
    @Published var showRatingSheet = false
    @Published var pendingRating = 4
    @Published var didComplete = false
    @Published var errorMessage: String? = nil

    /// Kitchen temperature in °C. Defaults to 24°C (75°F — the "benchmark" fermentation temp).
    @Published var kitchenTempC: Double = 24

    let recipe: Recipe
    private var timerCancellable: AnyCancellable? = nil

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    /// How much slower/faster fermentation runs at the current temp vs 24 °C.
    /// Formula: 2^((24 − T) / 10)  — fermentation roughly doubles every 10°C cooler.
    /// Examples:  18°C → 1.52×  |  24°C → 1.0×  |  30°C → 0.66×
    var tempAdjustmentFactor: Double {
        pow(2.0, (24.0 - kitchenTempC) / 10.0)
    }

    /// Human-readable adjustment label shown in the UI (e.g. "+52% longer" or "33% faster").
    var tempAdjustmentLabel: String {
        let f = tempAdjustmentFactor
        if abs(f - 1.0) < 0.03 { return "No adjustment" }
        let pct = Int(abs(f - 1.0) * 100)
        return f > 1.0 ? "+\(pct)% longer" : "\(pct)% faster"
    }

    var currentStep: RecipeStep? {
        guard let session else { return nil }
        let idx = session.currentStepIndex
        return idx < recipe.steps.count ? recipe.steps[idx] : nil
    }

    var isLastStep: Bool {
        guard let session else { return false }
        return session.currentStepIndex >= recipe.steps.count - 1
    }

    var completedSteps: Int { session?.currentStepIndex ?? 0 }

    // MARK: Start session

    func start(starterId: UUID, services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        do {
            session = try await services.bakes.startSession(starterId: starterId, recipe: recipe)
            resetTimer()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: Timer

    func toggleTimer() {
        timerRunning.toggle()
        if timerRunning {
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self else { return }
                    if self.secondsRemaining > 0 {
                        self.secondsRemaining -= 1
                    } else {
                        self.timerRunning = false
                        self.timerCancellable?.cancel()
                    }
                }
        } else {
            timerCancellable?.cancel()
        }
    }

    func resetTimer() {
        timerCancellable?.cancel()
        timerRunning = false
        let baseSecs = (currentStep?.durationMinutes ?? 0) * 60
        secondsRemaining = Int(Double(baseSecs) * tempAdjustmentFactor)
    }

    // MARK: Complete step

    func completeStep(services: ServiceContainer) async {
        guard let session, let step = currentStep else { return }
        isSaving = true
        defer { isSaving = false }
        timerCancellable?.cancel()
        timerRunning = false
        do {
            if isLastStep {
                showRatingSheet = true
            } else {
                self.session = try await services.bakes.completeStep(sessionId: session.id, stepId: step.id)
                resetTimer()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func finishBake(rating: Int, services: ServiceContainer) async {
        guard let session, let step = currentStep else { return }
        isSaving = true
        defer { isSaving = false }
        do {
            _ = try await services.bakes.completeStep(sessionId: session.id, stepId: step.id)
            self.session = try await services.bakes.completeSession(session.id, rating: rating)
            showRatingSheet = false
            didComplete = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - View

struct BakeSessionView: View {
    let recipe: Recipe
    @Environment(\.services)  private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm: BakeSessionViewModel
    @Environment(\.dismiss) private var dismiss

    /// Show the pre-bake temperature setup card until the user taps "Start Baking".
    @State private var showTempSetup = true
    @State private var navigateToLoafScan = false

    init(recipe: Recipe) {
        self.recipe = recipe
        _vm = StateObject(wrappedValue: BakeSessionViewModel(recipe: recipe))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header + progress
            VStack(spacing: SDSpace.s3) {
                BakeProgressBar(
                    totalSteps: recipe.steps.count,
                    completedSteps: vm.completedSteps,
                    currentStep: vm.completedSteps
                )
                .padding(.horizontal, SDSpace.screenMargin)

                // Temperature badge — shown after setup is dismissed
                if !showTempSetup && vm.session != nil {
                    HStack(spacing: 6) {
                        Image(systemName: "thermometer.medium")
                            .font(.system(size: 12))
                        Text("\(celsiusToFahrenheit(vm.kitchenTempC))°F · \(vm.tempAdjustmentLabel)")
                            .font(SDFont.captionMedium)
                    }
                    .foregroundStyle(tempBadgeColor)
                    .padding(.horizontal, SDSpace.s3)
                    .padding(.vertical, 4)
                    .background(tempBadgeColor.opacity(0.12))
                    .clipShape(Capsule())
                }
            }
            .padding(.vertical, SDSpace.s4)
            .background(SDColor.surface)

            if showTempSetup {
                tempSetupView
            } else if vm.isLoading {
                ProgressView("Starting bake…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let step = vm.currentStep {
                ScrollView {
                    BakeStepView(
                        step: step,
                        stepNumber: vm.completedSteps + 1,
                        totalSteps: recipe.steps.count,
                        secondsRemaining: vm.secondsRemaining,
                        timerRunning: vm.timerRunning,
                        onComplete: { Task { await vm.completeStep(services: services) } },
                        onToggleTimer: { vm.toggleTimer() }
                    )
                    .padding(.vertical, SDSpace.s4)
                }
            } else if vm.didComplete {
                completionView
            }
        }
        .sdBackground()
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(vm.session != nil && !vm.didComplete)
        .toolbar {
            if vm.session != nil && !vm.didComplete {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abandon") { dismiss() }
                        .foregroundStyle(SDColor.textSecondary)
                }
            }
        }
        .sheet(isPresented: $vm.showRatingSheet) {
            ratingSheet
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }

    // MARK: Temp setup card

    private var tempSetupView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SDSpace.s6) {
                // Icon + headline
                VStack(alignment: .leading, spacing: SDSpace.s2) {
                    Image(systemName: "thermometer.medium")
                        .font(.system(size: 36))
                        .foregroundStyle(SDColor.primary)
                    Text("Kitchen Temperature")
                        .font(SDFont.headingMedium)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("Fermentation slows in a cold kitchen and speeds up in a warm one. Set your kitchen temp and the bake timer adjusts automatically.")
                        .font(SDFont.bodyMedium)
                        .foregroundStyle(SDColor.textSecondary)
                }

                // Slider
                SDCard {
                    VStack(spacing: SDSpace.s4) {
                        HStack {
                            Text("Kitchen temp")
                                .font(SDFont.labelMedium)
                                .foregroundStyle(SDColor.textPrimary)
                            Spacer()
                            Text("\(celsiusToFahrenheit(vm.kitchenTempC))°F  (\(Int(vm.kitchenTempC))°C)")
                                .font(SDFont.labelLarge)
                                .foregroundStyle(SDColor.primary)
                        }

                        // Slider in °F for intuitive input; converts to °C for the formula
                        Slider(
                            value: Binding(
                                get: { Double(celsiusToFahrenheit(vm.kitchenTempC)) },
                                set: { vm.kitchenTempC = (($0 - 32) * 5 / 9).rounded() }
                            ),
                            in: 60...90, step: 1
                        )
                        .tint(SDColor.primary)
                        .onChange(of: vm.kitchenTempC) { _, _ in vm.resetTimer() }

                        HStack {
                            Text("60°F\nCold kitchen")
                                .font(SDFont.captionSmall)
                                .foregroundStyle(SDColor.textTertiary)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text("90°F\nWarm kitchen")
                                .font(SDFont.captionSmall)
                                .foregroundStyle(SDColor.textTertiary)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }

                // Adjustment preview
                SDCard(variant: .elevated) {
                    HStack(spacing: SDSpace.s4) {
                        Image(systemName: adjustmentIcon)
                            .font(.system(size: 28))
                            .foregroundStyle(tempBadgeColor)
                            .frame(width: 40)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(vm.tempAdjustmentLabel)
                                .font(SDFont.labelLarge)
                                .foregroundStyle(SDColor.textPrimary)
                            Text(adjustmentDescription)
                                .font(SDFont.captionMedium)
                                .foregroundStyle(SDColor.textSecondary)
                        }
                        Spacer()
                    }
                }

                // Step time preview
                if !recipe.steps.isEmpty {
                    VStack(alignment: .leading, spacing: SDSpace.s3) {
                        Text("Adjusted step times")
                            .font(SDFont.labelMedium)
                            .foregroundStyle(SDColor.textSecondary)
                        ForEach(recipe.steps.prefix(4)) { step in
                            HStack {
                                Text(step.title)
                                    .font(SDFont.captionMedium)
                                    .foregroundStyle(SDColor.textPrimary)
                                    .lineLimit(1)
                                Spacer()
                                let base = step.durationMinutes ?? 0
                                let adj = Int(Double(base) * vm.tempAdjustmentFactor)
                                if base != adj {
                                    Text("\(base)m → \(adj)m")
                                        .font(SDFont.captionMedium)
                                        .foregroundStyle(tempBadgeColor)
                                } else {
                                    Text("\(base)m")
                                        .font(SDFont.captionMedium)
                                        .foregroundStyle(SDColor.textSecondary)
                                }
                            }
                        }
                        if recipe.steps.count > 4 {
                            Text("+ \(recipe.steps.count - 4) more steps…")
                                .font(SDFont.captionSmall)
                                .foregroundStyle(SDColor.textTertiary)
                        }
                    }
                    .padding(SDSpace.s4)
                    .background(SDColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
                }

                // CTA
                SDButton(title: "Start Baking", isLoading: vm.isLoading) {
                    showTempSetup = false
                    Task {
                        let starterId = MockStarters.bubbles.id
                        await vm.start(starterId: starterId, services: services)
                    }
                }
            }
            .padding(SDSpace.screenMargin)
        }
    }

    // MARK: Helpers

    private var tempBadgeColor: Color {
        if vm.kitchenTempC < 20 { return SDColor.info }
        if vm.kitchenTempC > 27 { return SDColor.warning }
        return SDColor.success
    }

    private var adjustmentIcon: String {
        if vm.kitchenTempC < 20 { return "tortoise.fill" }
        if vm.kitchenTempC > 27 { return "hare.fill" }
        return "checkmark.circle.fill"
    }

    private var adjustmentDescription: String {
        if abs(vm.tempAdjustmentFactor - 1.0) < 0.03 {
            return "Your kitchen is at the ideal baking temp."
        }
        let mins = Int((vm.tempAdjustmentFactor - 1.0) * 60)
        if vm.tempAdjustmentFactor > 1.0 {
            return "Add ~\(mins)m per hour of fermentation in a cold kitchen."
        } else {
            return "Subtract ~\(abs(mins))m per hour — dough ferments faster when warm."
        }
    }

    private func celsiusToFahrenheit(_ c: Double) -> Int {
        Int(c * 9 / 5 + 32)
    }

    // MARK: Completion + rating

    private var completionView: some View {
        VStack(spacing: SDSpace.s6) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(SDColor.success)
            Text("Bake Complete!")
                .font(SDFont.displaySmall)
                .foregroundStyle(SDColor.textPrimary)
            Text("Your \(recipe.name) is done. Happy baking!")
                .font(SDFont.bodyLarge)
                .foregroundStyle(SDColor.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            VStack(spacing: SDSpace.s3) {
                SDButton(title: "Score My Bake with AI", icon: SDIcon.sparkles, style: .secondary) {
                    navigateToLoafScan = true
                }
                SDButton(title: "Done") { dismiss() }
            }
            .padding(.horizontal, SDSpace.screenMargin)
        }
        .navigationDestination(isPresented: $navigateToLoafScan) {
            AICameraView(mode: .loaf(vm.session))
        }
    }

    private var ratingSheet: some View {
        NavigationStack {
            VStack(spacing: SDSpace.s6) {
                Text("How did it turn out?")
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .padding(.top, SDSpace.s6)

                HStack(spacing: SDSpace.s4) {
                    ForEach(1...5, id: \.self) { star in
                        Button {
                            vm.pendingRating = star
                        } label: {
                            Image(systemName: star <= vm.pendingRating ? "star.fill" : "star")
                                .font(.system(size: 40))
                                .foregroundStyle(SDColor.accent)
                        }
                    }
                }

                Spacer()

                SDButton(title: "Save Rating", isLoading: vm.isSaving) {
                    Task { await vm.finishBake(rating: vm.pendingRating, services: services) }
                }
                .padding(.horizontal, SDSpace.screenMargin)
                .padding(.bottom, SDSpace.s8)
            }
            .sdBackground()
            .navigationTitle("Rate Your Bake")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        BakeSessionView(recipe: MockRecipes.classicSourdough)
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
