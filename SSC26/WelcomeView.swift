import SwiftUI

struct WelcomeView: View {
    var startAction: () -> Void
    @State private var isPressed = false
    @State private var pulse = false // for continuous scaling
    
    // Colors
    let accentGreen = Color(red: 0.29, green: 0.68, blue: 0.34)
    let bodyText = Color(red: 0.29, green: 0.37, blue: 0.33)
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.85, green: 0.93, blue: 1.0), Color(red: 0.96, green: 0.96, blue: 1.0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Icon + Title
                VStack(spacing: 10) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 54, weight: .light))
                        .foregroundColor(accentGreen)
                        .shadow(color: accentGreen.opacity(0.12), radius: 8, x: 0, y: 5)
                    
                    Text("XyloFingers")
                        .font(.system(size: 42, weight: .regular, design: .rounded))
                        .foregroundColor(accentGreen)
                        .shadow(color: accentGreen.opacity(0.12), radius: 8, x: 0, y: 5)
                }
                .padding(.bottom, 12)
                
                // Body text
                Text("Welcome! Your fingers are magic wands! Wave them and create magical melodies.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(bodyText)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 28)
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color(red: 1.0, green: 0.96, blue: 0.78).opacity(0.7))
                    )
                                
                // Circular pulsing button
                Button(action: {
                    withAnimation(.easeIn(duration: 0.15)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                        isPressed = false
                        startAction()
                    }
                }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120) // large circle
                        .background(accentGreen)
                        .clipShape(Circle())
                        .shadow(color: accentGreen.opacity(0.3), radius: 10, x: 0, y: 5)
                        .scaleEffect(isPressed ? 0.9 : (pulse ? 1.05 : 0.95)) // press + pulsing
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            pulse = true
        }
    }
}

#Preview {
    WelcomeView(startAction: {})
}
