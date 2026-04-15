import SwiftUI

/// Icon sizing scale per FIGMA_SPECS.md §Design Tokens > Icons.
enum SDIconSize {
    static let xs: CGFloat  = 16
    static let sm: CGFloat  = 20
    static let md: CGFloat  = 24
    static let lg: CGFloat  = 32
    static let xl: CGFloat  = 40
    static let xxl: CGFloat = 48
}

/// Canonical SF Symbol names used across the app. Using a single enum means
/// renaming an icon only requires one edit.
enum SDIcon {
    static let bread          = "leaf.fill"              // fallback — SF Symbols has no "bread"
    static let starterJar     = "cylinder.fill"
    static let starterBubbles = "bubbles.and.sparkles.fill"
    static let timer          = "timer"
    static let camera         = "camera.fill"
    static let chart          = "chart.line.uptrend.xyaxis"
    static let person         = "person.fill"
    static let gear           = "gearshape.fill"
    static let plus           = "plus"
    static let back           = "chevron.left"
    static let forward        = "chevron.right"
    static let down           = "chevron.down"
    static let up             = "chevron.up"
    static let close          = "xmark"
    static let edit           = "pencil"
    static let eye            = "eye"
    static let eyeSlash       = "eye.slash"
    static let bell           = "bell.fill"
    static let book           = "book.fill"
    static let checkmarkCircle = "checkmark.circle.fill"
    static let warningTriangle = "exclamationmark.triangle.fill"
    static let errorCircle     = "exclamationmark.circle.fill"
    static let infoCircle      = "info.circle.fill"
    static let star           = "star.fill"
    static let starOutline    = "star"
    static let house          = "house.fill"
    static let bookshelf      = "books.vertical.fill"
    static let flashOn        = "bolt.fill"
    static let flashOff       = "bolt.slash.fill"
    static let cameraFlip     = "arrow.triangle.2.circlepath.camera"
    static let snooze         = "moon.zzz.fill"
    static let trophy         = "trophy.fill"
    static let flame          = "flame.fill"
    static let pause          = "pause.fill"
    static let play           = "play.fill"
    static let checkmark      = "checkmark"
    static let stars          = "sparkles"
    static let sparkles       = "sparkles"
    static let photo          = "photo"
    static let waterDrop      = "drop.fill"
    static let drop           = "drop.fill"
    static let thermometer    = "thermometer"
    static let scale          = "scalemass.fill"
    static let clock          = "clock"
    static let recipe         = "book.closed.fill"
    static let grainFlour     = "scalemass.fill"
    static let feed           = "arrow.up.circle.fill"
    static let s9             = "9.circle"
}
