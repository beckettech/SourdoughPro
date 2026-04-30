import SwiftUI

/// What is the user trying to scan? Drives which AI endpoint we hit and which
/// results UI we render.
enum ScanMode: Equatable {
    case starter(Starter? = nil)
    case loaf(BakeSession? = nil)

    var headline: String {
        switch self {
        case .starter: return "Position starter in the frame"
        case .loaf:    return "Position the crumb / loaf in the frame"
        }
    }
    var loadingText: String {
        switch self {
        case .starter: return "Analysing starter…"
        case .loaf:    return "Analysing crumb & crust…"
        }
    }
    var contextLabel: String? {
        switch self {
        case .starter(let s):
            guard let name = s?.name else { return nil }
            return "Scan \(name)"
        case .loaf(let b):
            guard let name = b?.recipeName else { return nil }
            return "Scan \(name)"
        }
    }
}

@MainActor
final class AICameraViewModel: ObservableObject {
    @Published var isAnalyzing = false
    @Published var errorMessage: String? = nil
    @Published var result: AIResult? = nil
    @Published var showResults = false

    let camera = CameraController()
    let mode: ScanMode

    init(mode: ScanMode) {
        self.mode = mode
    }

    func captureAndAnalyze(services: ServiceContainer) async {
        errorMessage = nil
        isAnalyzing = true
        defer { isAnalyzing = false }

        do {
            let imageData: Data = camera.isAvailable
                ? try await camera.capturePhoto()
                : Data()

            switch mode {
            case .starter(let starter):
                let id = starter?.id ?? MockStarters.bubblesId
                let r = try await services.ai.analyzeStarter(imageData: imageData, starterId: id)
                result = .starter(r)
            case .loaf(let session):
                let id = session?.id ?? UUID()
                let r = try await services.ai.analyzeCrumb(imageData: imageData, bakeSessionId: id)
                result = .loaf(r)
            }
            showResults = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func start() { camera.start() }
    func stop()  { camera.stop() }
}

struct AICameraView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm: AICameraViewModel
    @Environment(\.dismiss) private var dismiss

    init(mode: ScanMode = .starter()) {
        _vm = StateObject(wrappedValue: AICameraViewModel(mode: mode))
    }

    /// Convenience for call sites that pass a `Starter` directly.
    init(starter: Starter) {
        _vm = StateObject(wrappedValue: AICameraViewModel(mode: .starter(starter)))
    }

    var body: some View {
        ZStack {
            // Camera preview / placeholder
            if vm.camera.isAvailable {
                CameraPreviewView(session: vm.camera.session)
                    .ignoresSafeArea()
            } else {
                Rectangle()
                    .fill(Color.black)
                    .ignoresSafeArea()
                VStack(spacing: SDSpace.s3) {
                    Image(systemName: SDIcon.camera)
                        .font(.system(size: 60))
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("Camera unavailable in simulator")
                        .font(SDFont.bodyMedium)
                        .foregroundStyle(Color.white.opacity(0.7))
                    Text("Tap the shutter to run mock analysis")
                        .font(SDFont.captionMedium)
                        .foregroundStyle(Color.white.opacity(0.5))
                }
            }

            // Overlay
            VStack {
                // Top bar
                HStack {
                    Button {
                        vm.stop()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    Spacer()
                    if let label = vm.mode.contextLabel {
                        Text(label)
                            .font(SDFont.labelMedium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, SDSpace.s4)
                            .padding(.vertical, SDSpace.s2)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, SDSpace.screenMargin)
                .padding(.top, SDSpace.s4)

                Spacer()

                // Focus frame
                RoundedRectangle(cornerRadius: SDRadius.lg)
                    .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    .frame(width: 260, height: 260)

                Spacer()

                // Instruction + shutter
                VStack(spacing: SDSpace.s4) {
                    if vm.isAnalyzing {
                        HStack(spacing: SDSpace.s3) {
                            ProgressView().tint(.white)
                            Text(vm.mode.loadingText)
                                .font(SDFont.labelMedium)
                                .foregroundStyle(.white)
                        }
                    } else {
                        Text(vm.mode.headline)
                            .font(SDFont.labelMedium)
                            .foregroundStyle(Color.white.opacity(0.8))
                    }

                    if let err = vm.errorMessage {
                        Text(err)
                            .font(SDFont.captionMedium)
                            .foregroundStyle(SDColor.error)
                            .multilineTextAlignment(.center)
                    }

                    SDShutterButton {
                        Task { await vm.captureAndAnalyze(services: services) }
                    }
                    .disabled(vm.isAnalyzing)
                    .opacity(vm.isAnalyzing ? 0.5 : 1)
                }
                .padding(.bottom, SDSpace.s10)
            }
        }
        .onAppear { vm.start() }
        .onDisappear { vm.stop() }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $vm.showResults) {
            if let r = vm.result {
                AnalysisResultsView(result: r)
            }
        }
    }
}

#Preview("Starter") {
    NavigationStack {
        AICameraView(mode: .starter(MockStarters.bubbles))
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}

#Preview("Loaf") {
    NavigationStack {
        AICameraView(mode: .loaf())
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
