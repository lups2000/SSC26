import SwiftUI

/// A visual effect that renders the index finger as a xylophone mallet
/// and animates musical effects when pinching (striking).
struct WandOverlay: View {
    let manager: HandTrackingManager
    
    @State private var sparkles: [SparkleParticle] = []
    @State private var lastPinchState: Bool = false
    
    var body: some View {
        ZStack {
            if manager.settings.isHandTrackingEnabled {
                // Draw wand for index finger (point 1)
                ForEach(manager.overlayPoints.indices, id: \.self) { i in
                    if i == 1 { // Index finger only
                        let point = manager.overlayPoints[i]
                        WandView(position: point, isPinching: isPinching)
                    }
                }
                
                // Draw sparkle particles
                ForEach(sparkles) { sparkle in
                    SparkleView(sparkle: sparkle)
                }
            }
        }
        .onChange(of: isPinching) { oldValue, newValue in
            if newValue && !oldValue {
                // Just started pinching - create sparkles!
                createSparkles()
            }
        }
        .onAppear {
            // Start animation loop to update sparkles
            startSparkleAnimation()
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
    
    /// Create sparkle particles at the wand tip
    private func createSparkles() {
        guard manager.overlayPoints.count >= 2 else { return }
        let wandTip = manager.overlayPoints[1]
        
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
                lifetime: Double.random(in: 0.3...0.5)
            ))
        }
    }
    
    /// Animation loop to update sparkle positions
    private func startSparkleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { _ in
            updateSparkles()
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
}

/// Visual representation of the xylophone mallet
struct WandView: View {
    let position: CGPoint
    let isPinching: Bool
    
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
                    .frame(width: 18, height: 200)
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
                    .frame(width: 16, height: 200)
                
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
                    .frame(width: 6, height: 200)
                    .offset(x: -5)
            }
            .offset(y: 90) // Moved down so finger is near the mallet head
            
            // MARK: - Mallet Head (the striking ball)
            
            ZStack {
                // Outer musical glow (always present, stronger when pinching)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.orange.opacity(isPinching ? 0.6 : 0.3),
                                Color.yellow.opacity(isPinching ? 0.4 : 0.15),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: isPinching ? 12 : 6)
                    .scaleEffect(isPinching ? 1.3 : 1.0)
                
                // The mallet ball (felt-covered head)
                ZStack {
                    // Shadow underneath
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .blur(radius: 3)
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
                                endRadius: 28
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.3), radius: isPinching ? 8 : 4)
                    
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
                                endRadius: 28
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    // Rim shadow for depth
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 56, height: 56)
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
    let color: Color = [Color.orange, Color.yellow].randomElement()!
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

#Preview {
    ZStack {
        Color.black.opacity(0.3)
        
        // Simulate wand at center with pinching
        WandView(position: CGPoint(x: 200, y: 300), isPinching: true)
    }
    .ignoresSafeArea()
}
