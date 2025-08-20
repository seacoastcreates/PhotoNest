import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    var onFinished: () -> Void

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaleEffect(isAnimating ? 1.0 : 0.9)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8), value: isAnimating)
                .frame( width: 256, height: 240)
            Text("PhotoNester")
                .font(.custom("Montserrat-SemiBold", size: 48))
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinished()
            }
        }
    }
}
