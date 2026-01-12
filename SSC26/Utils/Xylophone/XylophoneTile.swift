import SwiftUI

struct XylophoneTile: View {
    var note: String
    var color: Color
    var height: CGFloat
    var action: (() -> Void)? = nil

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }

            // Trigger the action (play sound)
            action?()

            // Reset after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
            }
        }) {
            Rectangle()
                .fill(color)
                .frame(height: height)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                            .padding(.top, 20)
                        Spacer()
                        Text(note)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        Spacer()
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                            .padding(.bottom, 20)
                    }
                )
                .padding(.horizontal, 16)
                .scaleEffect(isPressed ? 0.97 : 1)
                .offset(y: isPressed ? 4 : 0)
                .shadow(
                    color: color.opacity(isPressed ? 0.15 : 0.35),
                    radius: isPressed ? 4 : 8,
                    x: 0,
                    y: isPressed ? 2 : 6
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    XylophoneTile(note: "C", color: .red, height: 500) {
        SoundPlayer.shared.play(note: "C")
    }
}
