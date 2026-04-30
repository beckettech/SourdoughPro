import Foundation
import AVFoundation
import SwiftUI

/// Wraps AVCaptureSession for the camera preview.
/// In the simulator the camera is unavailable; the view falls back to a
/// placeholder without crashing.
final class CameraController: NSObject, ObservableObject {
    @Published var capturedImageData: Data? = nil
    @Published var isSessionRunning = false

    let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var continuation: CheckedContinuation<Data, Error>? = nil

    var isAvailable: Bool {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil
    }

    func start() {
        guard isAvailable else { return }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            configureAndStart()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted { self?.configureAndStart() }
            }
        default:
            break  // denied / restricted — view already handles unavailability
        }
    }

    private func configureAndStart() {
        // Avoid adding inputs/outputs more than once
        guard session.inputs.isEmpty else {
            if !session.isRunning { session.startRunning() }
            Task { @MainActor in self.isSessionRunning = true }
            return
        }
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
               let input = try? AVCaptureDeviceInput(device: device),
               self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
            }
            self.session.commitConfiguration()
            self.session.startRunning()
            await MainActor.run { self.isSessionRunning = true }
        }
    }

    func stop() {
        session.stopRunning()
        isSessionRunning = false
    }

    func capturePhoto() async throws -> Data {
        return try await withCheckedThrowingContinuation { cont in
            continuation = cont
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error {
            continuation?.resume(throwing: error)
        } else if let data = photo.fileDataRepresentation() {
            capturedImageData = data
            continuation?.resume(returning: data)
        } else {
            continuation?.resume(throwing: NSError(domain: "CameraController",
                                                    code: -1,
                                                    userInfo: [NSLocalizedDescriptionKey: "No photo data"]))
        }
        continuation = nil
    }
}

/// SwiftUI representable that shows the live camera preview layer.
/// Uses `layerClass` so the AVCaptureVideoPreviewLayer IS the backing layer —
/// it inherits bounds automatically and never gets stuck at zero frame.
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        // bounds-tracking is automatic via layerClass — nothing needed here
    }

    // MARK: UIView subclass whose backing layer is the preview layer
    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}
