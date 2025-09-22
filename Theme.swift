import SwiftUI

enum AppTheme {
    static let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.05, green: 0.08, blue: 0.18), Color(red: 0.11, green: 0.18, blue: 0.32)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardBackground = Color.white.opacity(0.12)
    static let surfaceBackground = Color.white.opacity(0.08)
    static let primaryAccent = Color(red: 0.36, green: 0.62, blue: 0.99)
    static let danger = Color(red: 0.96, green: 0.36, blue: 0.36)

    static func titleFont(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func bodyFont(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    static func buttonFont(_ size: CGFloat = 17) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
}
