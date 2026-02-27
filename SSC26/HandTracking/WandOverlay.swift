import SwiftUI

/// A visual effect that renders the index finger as a xylophone mallet
/// and animates musical effects when pinching (striking).
struct WandOverlay: View {
    let manager: HandTrackingManager
    
    @State private var sparkles: [SparkleParticle] = []
    @State private var impactEffects: [ImpactEffect] = []
    @State private var lastPinchState: Bool = false
    @State private var animationTimer: Timer? = nil
    
    var body: some View {
        ZStack {
            if manager.settings.isHandTrackingEnabled {
                // Draw wand for index finger (point 1)
                ForEach(manager.overlayPoints.indices, id: \.self) { i in
                    if i == 1 { // Index finger only
                        let point = manager.overlayPoints[i]
                        WandView(
                            position: point,
                            isPinching: isPinching,
                            noteColor: noteColor
                        )
                    }
                }
                
                // Draw sparkle particles
                ForEach(sparkles) { sparkle in
                    SparkleView(sparkle: sparkle)
                }
                
                // Draw impact effects with note names
                ForEach(impactEffects) { impact in
                    ImpactEffectView(impact: impact)
                }
            }
        }
        .onChange(of: isPinching) { oldValue, newValue in
            if newValue && !oldValue {
                // Just started pinching - create sparkles and impact!
                createSparkles()
                createImpactEffect()
            }
        }
        .onAppear {
            // Start animation loop to update sparkles and impacts
            startAnimationLoop()
        }
        .onDisappear {
            // CRITICAL: Stop and invalidate timer to prevent memory leak
            animationTimer?.invalidate()
            animationTimer = nil
        }
    }
    
    /// Check if currently pinching (both fingers close together)
    private var isPinching: Bool {
        guard manager.overlayPoints.count >= 2 else { return false }
        let thumb = manager.overlayPoints[0]
        let index = manager.overlayPoints[1]
        let distance = hypot(thumb.x - index.x, thumb.y - index.y)
        return distance < 60 // Same threshold as HandTrackingManager
    }
    
    /// Get the color for the current note being played
    private var noteColor: Color {
        guard let note = manager.currentNote else {
            return Color.yellow // Default color when no note
        }
        return NoteColorMapper.color(for: note)
    }
    
    /// Create impact effect when striking a note
    private func createImpactEffect() {
        guard manager.overlayPoints.count >= 2,
              let note = manager.currentNote else { return }
        
        let wandTip = manager.overlayPoints[1]
        let color = NoteColorMapper.color(for: note)
        
        impactEffects.append(ImpactEffect(
            position: wandTip,
            note: note,
            color: color
        ))
    }
    
    /// Create sparkle particles at the wand tip
    private func createSparkles() {
        guard manager.overlayPoints.count >= 2 else { return }
        let wandTip = manager.overlayPoints[1]
        let color = noteColor
        
        // Create 5-8 sparkles in random directions
        for _ in 0..<Int.random(in: 5...8) {
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 60...100)
            
            sparkles.append(SparkleParticle(
                position: wandTip,
                velocity: CGPoint(
                    x: cos(angle) * speed,
                    y: sin(angle) * speed
                ),
                lifetime: Double.random(in: 0.3...0.5),
                color: color
            ))
        }
    }
    
    /// Animation loop to update sparkles and impact effects
    private func startAnimationLoop() {
        // Invalidate any existing timer first
        animationTimer?.invalidate()
        
        // Create new timer and store reference for cleanup
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { [self] _ in
            updateSparkles()
            updateImpactEffects()
        }
    }
    
    /// Update sparkle positions and remove dead ones
    private func updateSparkles() {
        let deltaTime: CGFloat = 1/60.0
        
        sparkles = sparkles.compactMap { sparkle in
            var updated = sparkle
            updated.age += deltaTime
            
            // Remove if too old
            guard updated.age < updated.lifetime else { return nil }
            
            // Update position
            updated.position.x += updated.velocity.x * deltaTime
            updated.position.y += updated.velocity.y * deltaTime
            
            // Apply gravity
            updated.velocity.y += 300 * deltaTime
            
            return updated
        }
    }
    
    /// Update impact effect animations and remove finished ones
    private func updateImpactEffects() {
        let deltaTime: CGFloat = 1/60.0
        
        impactEffects = impactEffects.compactMap { effect in
            var updated = effect
            updated.age += deltaTime
            
            // Remove if animation complete
            guard updated.age < updated.duration else { return nil }
            
            return updated
        }
    }
}

/// Visual representation of the xylophone mallet
struct WandView: View {
    let position: CGPoint
    let isPinching: Bool
    let noteColor: Color
    
    var body: some View {
        ZStack {
            // MARK: - Mallet Handle (bottom section)
            
            // Handle grip with wood texture
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.70, green: 0.50, blue: 0.32),
                            Color(red: 0.78, green: 0.56, blue: 0.36),
                            Color(red: 0.70, green: 0.50, blue: 0.32)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 14, height: 70)
                .overlay {
                    // Wood grain effect
                    Capsule()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.4), radius: 3, x: -1, y: 2)
                .offset(y: 160) // Moved down so finger is near the mallet head
            
            // MARK: - Mallet Stick (main shaft)
            
            // Main stick body with taper
            ZStack {
                // Back shadow for depth
                Capsule()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 22, height: 240)
                    .blur(radius: 2)
                    .offset(x: 1, y: 1)
                
                // Main shaft
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.78, green: 0.58, blue: 0.38),
                                Color(red: 0.72, green: 0.53, blue: 0.34),
                                Color(red: 0.68, green: 0.50, blue: 0.32)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 20, height: 240)
                
                // Highlight on left edge
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 8, height: 240)
                    .offset(x: -6)
            }
            .offset(y: 90) // Moved down so finger is near the mallet head
            
            // MARK: - Mallet Head (the striking ball)
            
            ZStack {
                // Outer musical glow (always present, stronger when pinching)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                noteColor.opacity(isPinching ? 0.7 : 0.3),
                                noteColor.opacity(isPinching ? 0.5 : 0.15),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: isPinching ? 14 : 8)
                    .scaleEffect(isPinching ? 1.3 : 1.0)
                
                // The mallet ball (felt-covered head)
                ZStack {
                    // Shadow underneath
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 72, height: 72)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                    
                    // Main felt ball - outer layer
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.70, blue: 0.50),
                                    Color(red: 0.75, green: 0.60, blue: 0.42)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 34
                            )
                        )
                        .frame(width: 68, height: 68)
                        .shadow(color: .black.opacity(0.3), radius: isPinching ? 10 : 5)
                    
                    // Highlight to show sphere shape
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.0)
                                ],
                                center: UnitPoint(x: 0.3, y: 0.3),
                                startRadius: 0,
                                endRadius: 34
                            )
                        )
                        .frame(width: 68, height: 68)
                    
                    // Rim shadow for depth
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 68, height: 68)
                }
                .scaleEffect(isPinching ? 1.15 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPinching)
            }
            // Ball is now at position (0, 0) - right at the index finger tip!
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPinching)
        }
        .position(x: position.x, y: position.y)
    }
}

/// A single sparkle particle
struct SparkleParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var age: CGFloat = 0
    let lifetime: CGFloat
    let color: Color
    let size: CGFloat = CGFloat.random(in: 8...12)
}

/// Visual representation of a sparkle particle
struct SparkleView: View {
    let sparkle: SparkleParticle
    
    var body: some View {
        let progress = sparkle.age / sparkle.lifetime
        let opacity = (1.0 - progress) * 0.7
        let scale = 1.0 - (progress * 0.4)
        
        ZStack {
            // Outer glow (more subtle)
            Circle()
                .fill(sparkle.color.opacity(opacity * 0.2))
                .frame(width: sparkle.size * 1.5, height: sparkle.size * 1.5)
                .blur(radius: 3)
            
            // Main sparkle
            Image(systemName: "sparkle")
                .font(.system(size: sparkle.size))
                .foregroundStyle(sparkle.color)
                .opacity(opacity)
                .scaleEffect(scale)
                .shadow(color: sparkle.color.opacity(0.5), radius: 2)
                .rotationEffect(.degrees(progress * 90))
        }
        .position(sparkle.position)
    }
}

// MARK: - Impact Effect

/// An impact effect that shows the note name and visual burst when striking
struct ImpactEffect: Identifiable {
    let id = UUID()
    var position: CGPoint
    let note: String
    let color: Color
    var age: CGFloat = 0
    let duration: CGFloat = 0.6
}

/// Visual representation of an impact effect
struct ImpactEffectView: View {
    let impact: ImpactEffect
    
    var body: some View {
        let progress = impact.age / impact.duration
        let opacity = max(0, 1.0 - progress)
        let scale = 1.0 + (progress * 2.0) // Expands outward
        
        ZStack {
            // Multiple expanding rings with staggered timing (3 rings)
            ForEach(0..<3, id: \.self) { ringIndex in
                let delay = CGFloat(ringIndex) * 0.12
                let ringProgress = max(0, min(1, (progress - delay) / (1.0 - delay)))
                let ringOpacity = opacity * (1.0 - ringProgress)
                let ringScale = 1.0 + (ringProgress * 2.5)
                
                Circle()
                    .strokeBorder(
                        impact.color,
                        lineWidth: 4 - CGFloat(ringIndex) * 0.6
                    )
                    .frame(width: 60, height: 60)
                    .scaleEffect(ringScale)
                    .opacity(ringOpacity * 0.7)
            }
            
            // Subtle center glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(opacity * 0.5),
                            impact.color.opacity(opacity * 0.6),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(scale * 0.7)
                .blur(radius: 4)
        }
        .position(x: impact.position.x + 5, y: impact.position.y - 25)
    }
}

// MARK: - Note Color Mapping

/// Maps xylophone notes to rainbow colors
struct NoteColorMapper {
    static func color(for note: String) -> Color {
        switch note {
        case "C":
            return .red
        case "D":
            return .orange
        case "E":
            return .yellow
        case "F":
            return .green
        case "G":
            return .teal
        case "A":
            return .blue
        case "B":
            return .indigo
        case "C_H":
            return .purple
        default:
            return .yellow
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)
        
        // Simulate wand at center with pinching on note C
        WandView(
            position: CGPoint(x: 200, y: 300),
            isPinching: true,
            noteColor: .red
        )
        
        // Show an impact effect
        ImpactEffectView(
            impact: ImpactEffect(
                position: CGPoint(x: 200 + 10, y: 300 - 25),
                note: "C",
                color: .red,
                age: 0.1
            )
        )
    }
    .ignoresSafeArea()
}
