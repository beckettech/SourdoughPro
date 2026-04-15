import SwiftUI

extension Color {
    /// Initialise a `Color` from a 6- or 8-digit hex string.
    /// Accepts forms like `#8B4513`, `8B4513`, `#CC8B4513` (AARRGGBB).
    init(hex: String, opacity: Double = 1.0) {
        var hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexStr = hexStr.replacingOccurrences(of: "#", with: "")

        var intValue: UInt64 = 0
        Scanner(string: hexStr).scanHexInt64(&intValue)

        let a, r, g, b: Double
        switch hexStr.count {
        case 6:
            a = opacity
            r = Double((intValue >> 16) & 0xFF) / 255.0
            g = Double((intValue >> 8) & 0xFF) / 255.0
            b = Double(intValue & 0xFF) / 255.0
        case 8:
            a = Double((intValue >> 24) & 0xFF) / 255.0
            r = Double((intValue >> 16) & 0xFF) / 255.0
            g = Double((intValue >> 8) & 0xFF) / 255.0
            b = Double(intValue & 0xFF) / 255.0
        default:
            a = 1; r = 0; g = 0; b = 0
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
