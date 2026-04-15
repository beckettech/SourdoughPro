import SwiftUI

/// Camera shutter button per FIGMA_SPECS.md §AI Camera screen.
struct SDShutterButton: View {
    var isCapturing: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 72, height: 72)
                Circle()
                    .fill(Color.white)
                    .frame(width: isCapturing ? 48 : 60, height: isCapturing ? 48 : 60)
                    .animation(.easeInOut(duration: 0.1), value: isCapturing)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SDShutterButton { }
        .padding()
        .background(Color.black)
}
