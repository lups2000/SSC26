import SwiftUI

/// A reusable component for rendering hand tracking UI elements on top of other content.
/// Use this as the LAST item in your ZStack to ensure proper z-ordering.
struct HandTrackingControls: View {
    let manager: HandTrackingManager
    
    var body: some View {
        ZStack {
            // MARK: - Magic Wand Overlay (replaces index finger dot)
            if manager.settings.isHandTrackingEnabled {
                WandOverlay(manager: manager)
                
                // MARK: - Thumb overlay dot (keep the yellow thumb indicator)
                ForEach(manager.overlayPoints.indices, id: \.self) { i in
                    if i == 0 { // Only show thumb (index 0)
                        let point = manager.overlayPoints[i]
                        ZStack {
                            // Outer glow
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.yellow.opacity(0.4),
                                            Color.yellow.opacity(0)
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 20
                                    )
                                )
                                .frame(width: 40, height: 40)
                            
                            // Main dot
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 24, height: 24)
                            
                            // White stroke for contrast
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 24, height: 24)
                            
                            // Inner highlight
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.6), Color.white.opacity(0)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 24, height: 24)
                                .offset(y: -3)
                        }
                        .position(x: point.x, y: point.y)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                }
            }
            
            // MARK: - Control overlay (top-right corner)
            VStack {
                HStack {
                    Spacer()
                    
                    // Hand tracking device button
                    HandTrackingDeviceButton(
                        isEnabled: manager.settings.isHandTrackingEnabled,
                        isTracking: manager.isTracking,
                        onToggle: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                manager.settings.isHandTrackingEnabled.toggle()
                                if !manager.settings.isHandTrackingEnabled {
                                    manager.resetTracking()
                                }
                            }
                        }
                    )
                }
                
                Spacer()
            }
            .padding(.top, 60)
            .padding(.trailing, 20)
        }
        .allowsHitTesting(true) // Ensure controls remain interactive
    }
}

// MARK: - Hand Tracking Device Button

private struct HandTrackingDeviceButton: View {
    let isEnabled: Bool
    let isTracking: Bool
    let onToggle: () -> Void
    
    @State private var pulseAnimation = false
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 8) {
                // Device housing (looks like a camera/sensor)
                ZStack {
                    // Shadow/mount
                    Capsule()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 80, height: 12)
                        .offset(y: 38)
                        .blur(radius: 4)
                    
                    // Main device body
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.2, green: 0.2, blue: 0.22),
                                        Color(red: 0.15, green: 0.15, blue: 0.17)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Lens
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.black,
                                        Color(red: 0.1, green: 0.1, blue: 0.15)
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 20
                                )
                            )
                            .frame(width: 40, height: 40)
                            .overlay {
                                Circle()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 2)
                            }
                        
                        // Status indicator LED
                        Circle()
                            .fill(statusColor)
                            .frame(width: 8, height: 8)
                            .shadow(color: statusColor, radius: pulseAnimation ? 8 : 4)
                            .offset(x: 25, y: -20)
                            .opacity(isEnabled ? 1 : 0.3)
                        
                        // Hand icon indicator
                        Image(systemName: isEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(isEnabled ? .white : .gray)
                            .offset(x: -25, y: -20)
                    }
                    .frame(width: 70, height: 60)
                    .shadow(color: .black.opacity(0.4), radius: 6, x: 2, y: 3)
                }
                
                // Label
                Text(isEnabled ? "Hand Tracking" : "Touch Mode")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.35))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(Color.white.opacity(0.7))
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                pulseAnimation = true
            }
        }
    }
    
    private var statusColor: Color {
        if !isEnabled { return .gray }
        return isTracking ? .green : .orange
    }
}

#Preview("Hand Tracking Controls") {
    ZStack {
        Color.blue.opacity(0.3)
        HandTrackingControls(manager: HandTrackingManager())
    }
    .ignoresSafeArea()
}


