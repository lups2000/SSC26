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
            color: adaptiveColor.opacity(activePress ? 0.2 : 0.4),
            radius: activePress ? 6 : 12,
            x: 0,
            y: activePress ? 3 : 8
        )
        .shadow(
            color: Color.black.opacity(activePress ? 0.1 : 0.2),
            radius: activePress ? 2 : 4,
            x: 0,
            y: activePress ? 1 : 2
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
                                Color(red: 0.35, green: 0.35, blue: 0.4),
                                Color(red: 0.45, green: 0.45, blue: 0.5),
                                Color(red: 0.55, green: 0.55, blue: 0.6),
                                Color(red: 0.4, green: 0.4, blue: 0.45)
                            ],
                            center: UnitPoint(x: 0.4, y: 0.4),
                            startRadius: 2,
                            endRadius: 15
                        )
                    )
                    .frame(width: 30, height: 30)
                
                // Metallic ring effect
                Circle()
                    .strokeBorder(
                        AngularGradient(
                            colors: [
                                Color(red: 0.6, green: 0.6, blue: 0.65),
                                Color(red: 0.45, green: 0.45, blue: 0.5),
                                Color(red: 0.55, green: 0.55, blue: 0.6),
                                Color(red: 0.4, green: 0.4, blue: 0.45),
                                Color(red: 0.6, green: 0.6, blue: 0.65)
                            ],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 30, height: 30)
                
                // Top-left specular highlight (shiny metal)
                Circle()
                    .trim(from: 0.65, to: 0.85)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2.5)
                    .frame(width: 29, height: 29)
                    .rotationEffect(.degrees(-35))
                    .blur(radius: 0.8)
                
                // Bottom-right darker edge
                Circle()
                    .trim(from: 0.15, to: 0.35)
                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                    .frame(width: 29, height: 29)
                    .rotationEffect(.degrees(-35))
                    .blur(radius: 0.5)
                
                // Outer edge definition
                Circle()
                    .stroke(Color.black.opacity(0.6), lineWidth: 0.5)
                    .frame(width: 30, height: 30)
                
                // Inner edge (where it meets the hole)
                Circle()
                    .stroke(Color.black.opacity(0.4), lineWidth: 0.8)
                    .frame(width: 17, height: 17)
            }
            .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1.5)
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
                            endRadius: 8
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
                                Color.white.opacity(0.78),
                                Color.white.opacity(0.72)
                            ],
                            center: UnitPoint(x: 0.45, y: 0.45), // Slight offset for lighting
                            startRadius: 0,
                            endRadius: 8
                        )
                    )
                    .frame(width: 14, height: 14)
                
                // Top-left highlight (light catching the edge)
                Circle()
                    .trim(from: 0.6, to: 0.85)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                    .frame(width: 15, height: 15)
                    .rotationEffect(.degrees(-45))
                    .blur(radius: 0.5)
                
                // Bottom-right shadow (opposite side)
                Circle()
                    .trim(from: 0.1, to: 0.35)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 15, height: 15)
                    .rotationEffect(.degrees(-45))
                    .blur(radius: 0.5)
            }
            
            // Subtle highlight on edge
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .frame(width: 28, height: 28)
                .rotationEffect(.degrees(-45))
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
