import SwiftUI

extension View {
    /// Standard screen padding (16pt horizontal, matches FIGMA screen margin).
    func sdScreenPadding() -> some View {
        padding(.horizontal, SDSpace.screenMargin)
    }

    /// Applies the background colour so the rest of the design system sits on
    /// the canonical bread-paper surface.
    func sdBackground() -> some View {
        background(SDColor.background.ignoresSafeArea())
    }
}
