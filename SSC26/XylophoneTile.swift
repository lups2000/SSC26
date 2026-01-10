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
                            .font(.title2)
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
                .shadow(color: color.opacity(isPressed ? 0.6 : 0.3), radius: isPressed ? 10 : 6, x: 0, y: 4)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .brightness(isPressed ? 0.05 : 0.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    XylophoneTile(note: "C", color: .red, height: 100)
}
