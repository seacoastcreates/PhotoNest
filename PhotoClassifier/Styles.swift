import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.buttonFont())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [AppTheme.primaryAccent, AppTheme.primaryAccent.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: AppTheme.primaryAccent.opacity(configuration.isPressed ? 0.2 : 0.35), radius: configuration.isPressed ? 6 : 12, y: configuration.isPressed ? 3 : 8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.buttonFont())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [AppTheme.danger, AppTheme.danger.opacity(0.78)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: AppTheme.danger.opacity(configuration.isPressed ? 0.18 : 0.32), radius: configuration.isPressed ? 4 : 9, y: configuration.isPressed ? 2 : 6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

extension View {
    func glassCardStyle() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(AppTheme.cardBackground)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
            )
    }
}
