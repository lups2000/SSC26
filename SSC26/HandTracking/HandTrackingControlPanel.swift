import SwiftUI

// MARK: - Hand Tracking Control Panel (Reusable Component)

/// A reusable control panel for toggling hand tracking on/off with visual status indicators.
/// Can be used in any view that needs hand tracking controls.
struct HandTrackingControlPanel: View {
    let isEnabled: Bool
    let isTracking: Bool
    let onToggle: () async -> Void
    
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
                    Button(action: {
                        Task {
                            await onToggle()
                        }
                    }) {
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
                                .shadow(color: statusColor, radius: isEnabled ? 6 : 2)
                            
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
            .frame(width: 120, height: 110)
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
    
    /// Check if currently pinching (both fingers close together)
    private var isPinching: Bool {
        guard manager.overlayPoints.count >= 2 else { return false }
        let thumb = manager.overlayPoints[0]
        let index = manager.overlayPoints[1]
        let distance = hypot(thumb.x - index.x, thumb.y - index.y)
        return distance < 60 // Same threshold as HandTrackingManager
    }
    
    var body: some View {
        ZStack {
            // MARK: - Magic Wand Overlay
            if manager.settings.isHandTrackingEnabled {
                WandOverlay(manager: manager)
                
                // MARK: - Thumb overlay dot (anchor point)
                ForEach(manager.overlayPoints.indices, id: \.self) { i in
                    if i == 0 && !isPinching { // Only show thumb when not pinching
                        let point = manager.overlayPoints[i]
                        ZStack {
                            // Outer glow - subtle gray
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.gray.opacity(0.35),
                                            Color.gray.opacity(0.2),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 25
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .blur(radius: 5)
                            
                            // Main ring (hollow center) - gray
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.gray.opacity(0.9),
                                            Color.gray.opacity(0.7)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 20, height: 20)
                            
                            // Inner dot - simple white
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
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
    HandTrackingControlPanel(
        isEnabled: true,
        isTracking: true,
        onToggle: {
            print("Toggle tapped")
        }
    )
}
