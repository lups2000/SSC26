import SwiftUI

// MARK: - Hand Tracking Control Panel (Reusable Component)

/// A reusable control panel for toggling hand tracking on/off with visual status indicators.
/// Can be used in any view that needs hand tracking controls.
struct HandTrackingControlPanel: View {
    let isEnabled: Bool
    let isTracking: Bool
    let onToggle: () -> Void
    
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Control panel plate
            ZStack {
                // Shadow behind plate
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.black.opacity(0.2))
                    .blur(radius: 4)
                    .offset(x: 2, y: 3)
                
                // Main plate (cream/beige like classroom walls)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.92, green: 0.88, blue: 0.80),
                                Color(red: 0.88, green: 0.84, blue: 0.76)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    }
                
                VStack(spacing: 6) {
                    // Label engraved into plate
                    Text("HAND TRACKING")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color.black.opacity(0.4))
                        .kerning(0.5)
                        .shadow(color: .white.opacity(0.5), radius: 0, x: 0, y: 1)
                    
                    // Button/Switch
                    Button(action: onToggle) {
                        ZStack {
                            // Button housing
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color(red: 0.25, green: 0.25, blue: 0.27),
                                            Color(red: 0.15, green: 0.15, blue: 0.17)
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 25
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Circle()
                                        .stroke(Color.black.opacity(0.3), lineWidth: 2)
                                }
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                            
                            // Status indicator ring
                            Circle()
                                .stroke(statusColor, lineWidth: 2)
                                .frame(width: 44, height: 44)
                                .opacity(isEnabled ? 1 : 0.3)
                                .shadow(color: statusColor, radius: pulseAnimation && isEnabled ? 6 : 2)
                            
                            // Icon
                            Image(systemName: isEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(isEnabled ? .white : Color.gray.opacity(0.6))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Status text
                    Text(statusText)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(statusColor.opacity(0.8))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .fill(statusColor.opacity(0.15))
                        }
                }
                .padding(12)
            }
            .frame(width: 90, height: 110)
        }
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
    
    private var statusText: String {
        if !isEnabled { return "TOUCH" }
        return isTracking ? "ACTIVE" : "READY"
    }
}

// MARK: - Hand Tracking Visuals Only

/// Visual overlays for hand tracking (wand + thumb dot).
/// Does not include controls - use `HandTrackingControlPanel` separately for controls.
struct HandTrackingVisualsOnly: View {
    let manager: HandTrackingManager
    
    var body: some View {
        ZStack {
            // MARK: - Magic Wand Overlay
            if manager.settings.isHandTrackingEnabled {
                WandOverlay(manager: manager)
                
                // MARK: - Thumb overlay dot
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
        }
        .allowsHitTesting(false) // Visual only, not interactive
    }
}

// MARK: - Preview

#Preview("Control Panel") {
    ZStack {
        Color.gray.opacity(0.2)
        HandTrackingControlPanel(
            isEnabled: true,
            isTracking: true,
            onToggle: {
                print("Toggle tapped")
            }
        )
    }
}

#Preview("Visuals Only") {
    ZStack {
        Color.blue.opacity(0.3)
        HandTrackingVisualsOnly(manager: HandTrackingManager())
    }
    .ignoresSafeArea()
}
