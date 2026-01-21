import SwiftUI

struct ChalkboardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(red: 0.08, green: 0.08, blue: 0.09), Color(red: 0.06, green: 0.06, blue: 0.07)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                ZStack {
                    RadialGradient(
                        colors: [Color.white.opacity(0.06), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 400
                    )
                    RadialGradient(
                        colors: [Color.white.opacity(0.03), .clear],
                        center: .bottomTrailing,
                        startRadius: 0,
                        endRadius: 500
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            )
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.5, green: 0.32, blue: 0.14), Color(red: 0.38, green: 0.24, blue: 0.11)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.black.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 10)
            )
    }
}
