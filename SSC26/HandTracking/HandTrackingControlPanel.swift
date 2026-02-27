import SwiftUI

import SwiftUI

// MARK: - Hand Tracking Control Panel (Reusable Component)

/// A reusable control panel for toggling hand tracking on/off with visual status indicators.
/// Can be used in any view that needs hand tracking controls.
struct HandTrackingControlPanel: View {
    let isEnabled: Bool
    let isTracking: Bool
    let onToggle: () async -> Void
    
    var body: some View {
        ToggleCardButton(
            label: "Tracking",
            isEnabled: isEnabled,
            iconEnabled: "hand.raised.fill",
            iconDisabled: "hand.raised.slash.fill",
            statusColor: statusColor,
            statusText: statusText,
            onToggle: {
                Task {
                    await onToggle()
                }
            }
        )
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
                            // Outer glow - darker brown like mallet stick
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color(red: 0.78, green: 0.58, blue: 0.38).opacity(0.5),
                                            Color(red: 0.68, green: 0.50, blue: 0.32).opacity(0.3),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 30
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .blur(radius: 6)
                            
                            // Main ring (hollow center) - darker brown like mallet stick
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.78, green: 0.58, blue: 0.38),
                                            Color(red: 0.68, green: 0.50, blue: 0.32)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 4
                                )
                                .frame(width: 28, height: 28)
                            
                            // "T" for Thumb
                            Text("T")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.white)
                                .shadow(color: Color(red: 0.68, green: 0.50, blue: 0.32).opacity(0.8), radius: 2)
                        }
                        .position(x: point.x, y: point.y)
                        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 2)
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
        isEnabled: false,
        isTracking: true,
        onToggle: {
            print("Toggle tapped")
        }
    )
}
