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
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.bounds
        view.layer.addSublayer(preview)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let preview = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            preview.frame = uiView.bounds
        }
    }
}
