import SwiftUI

struct WelcomeView: View {
    var startAction: () -> Void
    
    var body: some View {
        VStack(spacing: 36) {
            Spacer()
            Text("Xylophone App")
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text("Welcome! Get ready to play an interactive xylophone using your fingers and the iPad's camera.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            Button(action: startAction) {
                Text("Start Learning Experience")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 36)
                    .padding(.vertical, 16)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WelcomeView(startAction: {})
}
