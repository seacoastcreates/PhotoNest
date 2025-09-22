import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 24) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .scaleEffect(isAnimating ? 1.0 : 0.92)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .shadow(color: AppTheme.primaryAccent.opacity(0.45), radius: 22, y: 12)

                VStack(spacing: 8) {
                    Text("PhotoNester")
                        .font(AppTheme.titleFont(44))
                        .foregroundStyle(.white)
                        .opacity(isAnimating ? 1 : 0)

                    Text("Curated nests for every moment")
                        .font(AppTheme.bodyFont(18))
                        .foregroundStyle(Color.white.opacity(0.75))
                        .opacity(isAnimating ? 1 : 0)
                }
            }
            .padding(40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinished()
            }
        }
    }
}
