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

    let recipe: Recipe
    private var timerCancellable: AnyCancellable? = nil

    init(recipe: Recipe) {
        self.recipe = recipe
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

    private func resetTimer() {
        timerCancellable?.cancel()
        timerRunning = false
        secondsRemaining = (currentStep?.durationMinutes ?? 0) * 60
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

struct BakeSessionView: View {
    let recipe: Recipe
    @Environment(\.services)  private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm: BakeSessionViewModel
    @Environment(\.dismiss) private var dismiss

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
            }
            .padding(.vertical, SDSpace.s4)
            .background(SDColor.surface)

            if vm.isLoading {
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
        .task {
            if vm.session == nil {
                let starterId = appState.user.flatMap { _ in MockStarters.bubbles.id } ?? MockStarters.bubbles.id
                await vm.start(starterId: starterId, services: services)
            }
        }
    }

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
            SDButton(title: "Done") { dismiss() }
                .padding(.horizontal, SDSpace.screenMargin)
        }
    }

    private var ratingSheet: some View {
        NavigationStack {
            VStack(spacing: SDSpace.s6) {
                Text("How did it turn out?")
                    .font(SDFont.displaySmall)
                    .foregroundStyle(SDColor.textPrimary)
                    .padding(.top, SDSpace.s6)

                // Star picker
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
