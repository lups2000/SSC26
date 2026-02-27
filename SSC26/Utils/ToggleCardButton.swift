import SwiftUI

// MARK: - Toggle Card Button (Reusable Base Component)

/// A reusable card-style toggle button with thumbtacks, label, icon, and status badge
struct ToggleCardButton: View {
    let label: String
    let isEnabled: Bool
    let iconEnabled: String
    let iconDisabled: String
    let statusColor: Color
    let statusText: String
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Control button card
            ZStack {
                // Soft shadow behind button
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black.opacity(0.15))
                    .blur(radius: 8)
                    .offset(x: 0, y: 4)
                
                // Main button card (soft yellow/cream tone)
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.98, green: 0.96, blue: 0.88),
                                Color(red: 0.96, green: 0.94, blue: 0.86)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.black.opacity(0.12),
                                        Color.black.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                
                // Thumbtack/pin centered at top
                ThumbTackView()
                    .offset(x: 0, y: -62)
                
                VStack(spacing: 8) {
                    // Label
                    Text(label)
                        .font(.custom("Marker Felt", size: 13))
                        .foregroundStyle(Color.black.opacity(0.6))
                        .tracking(0.3)
                    
                    // Button
                    Button(action: onToggle) {
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
                                .frame(width: 52, height: 52)
                            
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
                                    lineWidth: 2.5
                                )
                                .frame(width: 52, height: 52)
                            
                            // Icon
                            Image(systemName: isEnabled ? iconEnabled : iconDisabled)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(
                                    isEnabled ? statusColor : Color.gray.opacity(0.5)
                                )
                                .symbolEffect(.bounce, value: isEnabled)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Status indicator badge
                    HStack(spacing: 3) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 5, height: 5)
                            .shadow(color: statusColor.opacity(0.6), radius: 2)
                        
                        Text(statusText)
                            .font(.custom("Marker Felt", size: 10))
                            .foregroundStyle(Color.black.opacity(0.7))
                            .tracking(0.5)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background {
                        Capsule()
                            .fill(statusColor.opacity(0.15))
                            .overlay {
                                Capsule()
                                    .stroke(statusColor.opacity(0.3), lineWidth: 1)
                            }
                    }
                }
                .padding(12)
            }
            .frame(width: 115, height: 115)
        }
    }
}

// MARK: - Thumbtack Component

/// A decorative thumbtack/pin for the control panels
private struct ThumbTackView: View {
    var body: some View {
        ZStack {
            // Pin needle (the pointy part going into the board)
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.65, green: 0.55, blue: 0.40).opacity(0.7),
                            Color(red: 0.50, green: 0.42, blue: 0.30).opacity(0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 2, height: 8)
                .offset(y: 6)
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0.5, y: 0.5)
            
            // Pin head shadow (larger, softer)
            Circle()
                .fill(Color.black.opacity(0.18))
                .frame(width: 11, height: 11)
                .blur(radius: 2.5)
                .offset(x: 0.5, y: 1.5)
            
            // Pin head base (darker outer ring for depth)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.72, green: 0.60, blue: 0.42),
                            Color(red: 0.60, green: 0.50, blue: 0.36)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 5
                    )
                )
                .frame(width: 12, height: 12)
            
            // Pin head main body - warm brass/bronze tone
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.80, green: 0.68, blue: 0.48), // Mid brass tone
                            Color(red: 0.65, green: 0.55, blue: 0.40)  // Shadow edge
                        ],
                        center: UnitPoint(x: 0.35, y: 0.35), // Off-center highlight
                        startRadius: 0,
                        endRadius: 5
                    )
                )
                .frame(width: 9, height: 9)
            
            // Subtle rim light (opposite side of highlight)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.88, blue: 0.70).opacity(0.25),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
                .frame(width: 9, height: 9)
        }
    }
}

// MARK: - Preview

#Preview("Toggle Card Buttons") {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
        HStack(spacing: 12) {
            ToggleCardButton(
                label: "Sound",
                isEnabled: true,
                iconEnabled: "speaker.wave.3.fill",
                iconDisabled: "speaker.slash.fill",
                statusColor: .blue,
                statusText: "ON",
                onToggle: {
                    print("Sound toggled")
                }
            )
            
            ToggleCardButton(
                label: "Hand Tracking",
                isEnabled: true,
                iconEnabled: "hand.raised.fill",
                iconDisabled: "hand.raised.slash.fill",
                statusColor: .green,
                statusText: "TRACKING",
                onToggle: {
                    print("Hand tracking toggled")
                }
            )
        }
    }
}
