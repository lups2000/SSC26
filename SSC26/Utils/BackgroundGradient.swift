import SwiftUI

struct BackgroundGradient: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LinearGradient(
            colors: colorScheme == .dark ? [
                Color(red: 0.08, green: 0.09, blue: 0.15),  // Slightly lighter
                Color(red: 0.11, green: 0.09, blue: 0.15)   // Slightly lighter
            ] : [
                Color(red: 0.85, green: 0.93, blue: 1.0),
                Color(red: 0.96, green: 0.96, blue: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
