import SwiftUI

struct XylophoneTileView: View {
    var note: String
    var color: Color
    var height: CGFloat
    var isExternallyPressed: Bool = false
    var action: (() -> Void)? = nil

    @State private var isPressed = false
    @State private var showVibration = false
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
    
    /// Scale the vibration effect based on tile height - shorter tiles get more pronounced effects
    private var vibrationScale: CGFloat {
        // Normalize height: smaller tiles (300) get 1.08, taller tiles (580) get 1.05
        let normalized = (height - 300) / (580 - 300) // 0.0 for shortest, 1.0 for tallest
        return 1.08 - (normalized * 0.03) // 1.08 for shortest, 1.05 for tallest
    }

    var body: some View {
        let activePress = isPressed || isExternallyPressed // Combine both press states
        
        ZStack {
            // Main xylophone bar
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(adaptiveColor)
                .frame(height: height)
                .overlay(
                    // Subtle wood grain texture
                    WoodGrainOverlay()
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .opacity(0.12)
                )
                .overlay(
                    // Subtle edge definition
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(
                            Color.black.opacity(0.15),
                            lineWidth: 1
                        )
                )
                .overlay(
                    // Content overlay (circles and text)
                    VStack {
                        MountingHole()
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        Text(note)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                        
                        Spacer()
                        
                        MountingHole()
                            .padding(.bottom, 20)
                    }
                )
                .padding(.horizontal, 16)
            
            // Vibration glow effect when pressed
            if showVibration || activePress {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(adaptiveColor.opacity(0.6), lineWidth: 3)
                    .frame(height: height)
                    .padding(.horizontal, 16)
                    .blur(radius: 8)
                    .scaleEffect(showVibration ? 1.05 : 1.0)
                    .opacity(showVibration ? 0 : 0.8)
            }
        }
        .scaleEffect(activePress ? 0.97 : 1)
        .offset(y: activePress ? 3 : 0)
        .shadow(
            color: Color.black.opacity(0.20),
            radius: 2,
            x: 0,
            y: 1
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            // Vibration glow effect
            showVibration = true
            withAnimation(.easeOut(duration: 0.4)) {
                showVibration = false
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
        .animation(.easeInOut(duration: 0.15), value: isExternallyPressed) // Animate external presses
        .onChange(of: isExternallyPressed) { _, newValue in
            if newValue {
                showVibration = true
                withAnimation(.easeOut(duration: 0.4)) {
                    showVibration = false
                }
            }
        }
    }
}

// Realistic mounting hole/grommet
struct MountingHole: View {
    var body: some View {
        ZStack {
            // Outer ring (metal/rubber grommet)
            ZStack {
                // Base grommet with realistic gradient
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.40, green: 0.40, blue: 0.43),
                                Color(red: 0.48, green: 0.48, blue: 0.52),
                                Color(red: 0.58, green: 0.58, blue: 0.62),
                                Color(red: 0.45, green: 0.45, blue: 0.48)
                            ],
                            center: UnitPoint(x: 0.4, y: 0.4),
                            startRadius: 2,
                            endRadius: 10
                        )
                    )
                    .frame(width: 30, height: 30)
                
                // Outer edge definition
                Circle()
                    .stroke(Color.black.opacity(0.6), lineWidth: 0.5)
                    .frame(width: 30, height: 30)
                
                // Inner edge (where it meets the hole)
                Circle()
                    .stroke(Color.black.opacity(0.4), lineWidth: 0.8)
                    .frame(width: 17, height: 17)
            }
            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1.5)
            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 0.5)
            
            // Inner hole (drilled through effect)
            ZStack {
                // Dark inner shadow to show depth
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 10
                        )
                    )
                    .frame(width: 16, height: 16)
                    .blur(radius: 1)
                
                // Bright white hole showing through
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.68),
                                Color.white.opacity(0.62)
                            ],
                            center: UnitPoint(x: 0.45, y: 0.45), // Slight offset for lighting
                            startRadius: 0,
                            endRadius: 20
                        )
                    )
                    .frame(width: 14, height: 14)

            }
            
        }
    }
}

// Subtle wood grain texture overlay
struct WoodGrainOverlay: View {
    var body: some View {
        Canvas { context, size in
            // Horizontal grain lines (xylophone bars have horizontal grain)
            let grainLines = 6
            for i in 0..<grainLines {
                let y = (CGFloat(i) / CGFloat(grainLines)) * size.height
                let offsetY = sin(CGFloat(i) * 0.5) * 2
                
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y + offsetY))
                
                // Create subtle wavy grain lines
                let segments = 15
                for j in 0...segments {
                    let x = (CGFloat(j) / CGFloat(segments)) * size.width
                    let wave = sin(CGFloat(j) * 0.4 + CGFloat(i) * 0.2) * 1.5
                    path.addLine(to: CGPoint(x: x, y: y + offsetY + wave))
                }
                
                let opacity = (sin(CGFloat(i) * 0.9) * 0.5 + 0.5) * 0.15
                context.stroke(
                    path,
                    with: .color(.black.opacity(opacity)),
                    lineWidth: 0.5
                )
            }
        }
    }
}

#Preview {
    XylophoneTileView(note: "C", color: .red, height: 500) {
        SoundPlayer.shared.play(note: "C")
    }
}
