import SwiftUI

struct XylophoneTileView: View {
    var note: String
    var color: Color
    var height: CGFloat
    var action: (() -> Void)? = nil

    @State private var isPressed = false
    @Environment(\.colorScheme) private var colorScheme
    
    /// Returns a darker, less saturated version of the color for dark mode
    private var adaptiveColor: Color {
        guard colorScheme == .dark else { return color }
        
        // Extract color components and reduce brightness/saturation for dark mode
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Reduce brightness and saturation slightly for dark mode
        return Color(hue: Double(hue), 
                    saturation: Double(saturation * 0.95),
                    brightness: Double(brightness * 0.8))
    }

    var body: some View {
        Rectangle()
            .fill(adaptiveColor)
            .frame(height: height)
            .cornerRadius(12)
            .overlay(
                VStack {
                    Circle()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.8) : Color.white)
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
                        .fill(colorScheme == .dark ? Color.white.opacity(0.8) : Color.white)
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 20)
                }
            )
            .padding(.horizontal, 16)
            .scaleEffect(isPressed ? 0.97 : 1)
            .offset(y: isPressed ? 3 : 0)
            .shadow(
                color: adaptiveColor.opacity(isPressed ? 0.15 : 0.35),
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 6
            )
            .contentShape(Rectangle())
            .onTapGesture {
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
            }
    }
}

#Preview {
    XylophoneTileView(note: "C", color: .red, height: 500) {
        SoundPlayer.shared.play(note: "C")
    }
}
