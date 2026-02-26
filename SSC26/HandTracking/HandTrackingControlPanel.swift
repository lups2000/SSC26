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
            // MARK: - Control panel card
            ZStack {
                // Soft shadow behind panel
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.black.opacity(0.15))
                    .blur(radius: 8)
                    .offset(x: 0, y: 4)
                
                // Main panel card (white/cream with subtle gradient)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color(red: 0.98, green: 0.97, blue: 0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.8),
                                        Color.black.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Thumbtacks/pins at top corners
                ThumbTackView()
                    .offset(x: -55, y: -62)
                
                ThumbTackView()
                    .offset(x: 55, y: -62)
                
                VStack(spacing: 10) {
                    // Label
                    Text("Hand Tracking")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.6))
                        .tracking(0.3)
                    
                    // Button/Switch
                    Button(action: {
                        Task {
                            await onToggle()
                        }
                    }) {
                        ZStack {
                            // Button background with glow effect when enabled
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: isEnabled ? [
                                            statusColor.opacity(0.2),
                                            statusColor.opacity(0.1)
                                        ] : [
                                            Color.gray.opacity(0.08),
                                            Color.gray.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                            
                            // Outer ring
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: isEnabled ? [
                                            statusColor.opacity(0.6),
                                            statusColor.opacity(0.4)
                                        ] : [
                                            Color.gray.opacity(0.3),
                                            Color.gray.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 64, height: 64)
                            
                            // Icon
                            Image(systemName: isEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(
                                    isEnabled ? statusColor : Color.gray.opacity(0.5)
                                )
                                .symbolEffect(.bounce, value: isEnabled)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Status indicator badge
                    HStack(spacing: 4) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 6, height: 6)
                            .shadow(color: statusColor.opacity(0.6), radius: 3)
                        
                        Text(statusText)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.black.opacity(0.7))
                            .tracking(0.5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(statusColor.opacity(0.15))
                            .overlay {
                                Capsule()
                                    .stroke(statusColor.opacity(0.3), lineWidth: 1)
                            }
                    }
                }
                .padding(16)
            }
            .frame(width: 140, height: 140)
        }
    }
    
    private var statusColor: Color {
        if !isEnabled { return Color(red: 0.6, green: 0.6, blue: 0.65) }
        return isTracking ? .green : .orange
    }
    
    private var statusText: String {
        if !isEnabled { return "TOUCH MODE" }
        return isTracking ? "TRACKING" : "WAITING"
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

// MARK: - Thumbtack Component

/// A decorative thumbtack/pin for the control panel
private struct ThumbTackView: View {
    var body: some View {
        ZStack {
            // Shadow
            Circle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 12, height: 12)
                .blur(radius: 2)
                .offset(x: 0.2, y: 1)
            
            // Pin head (main body) - light wood/brown
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.75, green: 0.76, blue: 0.78),
                            Color(red: 0.60, green: 0.61, blue: 0.63)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 8, height: 8)
        }
    }
}

// MARK: - Preview

#Preview("Control Panel") {
    HandTrackingControlPanel(
        isEnabled: false,
        isTracking: true,
        onToggle: {
            print("Toggle tapped")
        }
    )
}
