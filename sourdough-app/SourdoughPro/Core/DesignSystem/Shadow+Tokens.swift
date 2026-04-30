import SwiftUI

/// Shadow tokens per FIGMA_SPECS.md §Design Tokens > Shadows.
struct SDShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let sm      = SDShadow(color: Color.black.opacity(0.04), radius: 4,  x: 0, y: 1)
    static let md      = SDShadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 2)
    static let lg      = SDShadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 4)
    static let xl      = SDShadow(color: Color.black.opacity(0.16), radius: 48, x: 0, y: 8)
    static let card    = SDShadow(color: Color(red: 139/255, green: 69/255, blue: 19/255).opacity(0.08), radius: 16, x: 0, y: 4)
    static let button  = SDShadow(color: Color(red: 139/255, green: 69/255, blue: 19/255).opacity(0.12), radius: 8,  x: 0, y: 2)
}

extension View {
    func sdShadow(_ shadow: SDShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
