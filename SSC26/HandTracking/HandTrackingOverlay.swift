import SwiftUI

/// A reusable component for rendering hand tracking UI elements on top of other content.
/// Use this as the LAST item in your ZStack to ensure proper z-ordering.
struct HandTrackingControls: View {
    let manager: HandTrackingManager
    
    var body: some View {
        ZStack {
            // MARK: - Finger-tip overlay dots
            if manager.settings.isHandTrackingEnabled {
                ForEach(manager.overlayPoints.indices, id: \.self) { i in
                    let point = manager.overlayPoints[i]
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        (i == 1 ? Color.red : Color.yellow).opacity(0.4),
                                        (i == 1 ? Color.red : Color.yellow).opacity(0)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 20
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        // Main dot
                        Circle()
                            .fill(i == 1 ? Color.red : Color.yellow) // red = index, yellow = thumb
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
            
            // MARK: - Control overlay (top-right)
            VStack {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        // Hand tracking toggle button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                manager.settings.isHandTrackingEnabled.toggle()
                                if !manager.settings.isHandTrackingEnabled {
                                    manager.resetTracking()
                                }
                            }
                        }) {
                            VStack(spacing: 8) {
                                // Icon
                                ZStack {
                                    Circle()
                                        .fill(manager.settings.isHandTrackingEnabled ?
                                            LinearGradient(colors: [.blue.opacity(0.3), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom) :
                                            LinearGradient(colors: [.orange.opacity(0.3), .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                                        )
                                        .frame(width: 56, height: 56)
                                    
                                    Image(systemName: manager.settings.isHandTrackingEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(manager.settings.isHandTrackingEnabled ? .blue : .orange)
                                }
                                
                                // Label
                                VStack(spacing: 2) {
                                    Text(manager.settings.isHandTrackingEnabled ? "Hand Tracking" : "Touch Mode")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    
                                    Text(manager.settings.isHandTrackingEnabled ? "TAP TO DISABLE" : "TAP TO ENABLE")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(16)
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // Tracking status badge (only show when hand tracking is enabled)
                        if manager.settings.isHandTrackingEnabled {
                            HStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(manager.isTracking ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                        .frame(width: 20, height: 20)
                                    
                                    Circle()
                                        .fill(manager.isTracking ? Color.green : Color.red)
                                        .frame(width: 10, height: 10)
                                }
                                
                                Text(manager.isTracking ? "Active" : "Inactive")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background {
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                            }
                            .overlay {
                                Capsule()
                                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.trailing, 10)
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


