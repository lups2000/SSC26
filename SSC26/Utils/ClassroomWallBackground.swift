import SwiftUI

/// A subtle classroom wall background with warm tones and texture
/// that allows the camera feed to bleed through slightly
struct ClassroomWallBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Base wall color - warm beige like a classroom
            LinearGradient(
                colors: colorScheme == .dark ? [
                    Color(red: 0.12, green: 0.11, blue: 0.10),  // Dark warm gray
                    Color(red: 0.15, green: 0.14, blue: 0.13)   // Slightly lighter
                ] : [
                    Color(red: 0.95, green: 0.93, blue: 0.88),  // Warm cream
                    Color(red: 0.92, green: 0.90, blue: 0.85)   // Slightly darker cream
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Subtle wall texture/grain (very faint)
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.015),
                            Color.black.opacity(0.015)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blendMode(.overlay)
            
            // Optional: Very faint bulletin board silhouette in background
            if colorScheme == .light {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.brown.opacity(0.03))
                    .frame(width: 400, height: 300)
                    .rotationEffect(.degrees(0.5))
                    .offset(x: -450, y: 100)
                    .blur(radius: 20)
            }
            
            // Vignette effect (darker edges) for depth
            RadialGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08)
                ],
                center: .center,
                startRadius: 100,
                endRadius: 800
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ClassroomWallBackground()
}
