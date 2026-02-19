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
                    
                    VStack(spacing: 12) {
                        // Hand tracking toggle button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                manager.settings.isHandTrackingEnabled.toggle()
                                if !manager.settings.isHandTrackingEnabled {
                                    manager.resetTracking()
                                }
                            }
                        }) {
                            HStack(spacing: 10) {
                                // Icon
                                ZStack {
                                    Circle()
                                        .fill(manager.settings.isHandTrackingEnabled ?
                                            LinearGradient(colors: [.blue.opacity(0.3), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom) :
                                            LinearGradient(colors: [.orange.opacity(0.3), .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                                        )
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: manager.settings.isHandTrackingEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(manager.settings.isHandTrackingEnabled ? .blue : .orange)
                                }
                                
                                // Label
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(manager.settings.isHandTrackingEnabled ? "Hand Tracking" : "Touch Mode")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    
                                    Text(manager.settings.isHandTrackingEnabled ? "Tap to disable" : "Tap to enable")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background {
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                            }
                            .overlay {
                                Capsule()
                                    .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // Tracking status badge (only show when hand tracking is enabled)
                        if manager.settings.isHandTrackingEnabled {
                            HStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(manager.isTracking ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                        .frame(width: 18, height: 18)
                                    
                                    Circle()
                                        .fill(manager.isTracking ? Color.green : Color.red)
                                        .frame(width: 9, height: 9)
                                        .shadow(color: manager.isTracking ? .green : .red, radius: 4)
                                }
                                
                                Text(manager.isTracking ? "Active" : "Inactive")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background {
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
                            }
                            .overlay {
                                Capsule()
                                    .strokeBorder((manager.isTracking ? Color.green : Color.red).opacity(0.3), lineWidth: 1.5)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.top, 60)  // Extra padding to clear status bar
            .padding(.trailing, 20)
        }
        .allowsHitTesting(true) // Ensure controls remain interactive
    }
}

#Preview("Hand Tracking Controls") {
    ZStack {
        Color.blue.opacity(0.3)
        HandTrackingControls(manager: HandTrackingManager())
    }
    .ignoresSafeArea()
}


