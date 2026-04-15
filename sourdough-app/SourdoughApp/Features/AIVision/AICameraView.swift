import SwiftUI

@MainActor
final class AICameraViewModel: ObservableObject {
    @Published var isAnalyzing = false
    @Published var errorMessage: String? = nil
    @Published var analysis: StarterAnalysis? = nil
    @Published var showResults = false

    let camera = CameraController()
    let starter: Starter?

    init(starter: Starter? = nil) {
        self.starter = starter
    }

    func captureAndAnalyze(services: ServiceContainer) async {
        errorMessage = nil
        isAnalyzing = true
        defer { isAnalyzing = false }

        do {
            // If real camera unavailable (Simulator) use empty placeholder data
            let imageData: Data
            if camera.isAvailable {
                imageData = try await camera.capturePhoto()
            } else {
                imageData = Data() // mock service ignores the data
            }

            let targetId = starter?.id ?? MockStarters.bubblesId
            analysis = try await services.ai.analyzeStarter(imageData: imageData, starterId: targetId)
            showResults = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func start() { camera.start() }
    func stop()  { camera.stop() }
}

struct AICameraView: View {
    var starter: Starter? = nil
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm: AICameraViewModel
    @Environment(\.dismiss) private var dismiss

    init(starter: Starter? = nil) {
        self.starter = starter
        _vm = StateObject(wrappedValue: AICameraViewModel(starter: starter))
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
                    if let name = vm.starter?.name {
                        Text("Scan \(name)")
                            .font(SDFont.labelMedium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, SDSpace.s4)
                            .padding(.vertical, SDSpace.s2)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Capsule())
                    }
                    Spacer()
                    // Balance spacer
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
                            ProgressView()
                                .tint(.white)
                            Text("Analysing starter…")
                                .font(SDFont.labelMedium)
                                .foregroundStyle(.white)
                        }
                    } else {
                        Text("Position starter in the frame")
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
            if let analysis = vm.analysis {
                AnalysisResultsView(analysis: analysis)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AICameraView(starter: MockStarters.bubbles)
    }
    .environmentObject(AppState(services: .preview()))
    .environment(\.services, .preview())
}
