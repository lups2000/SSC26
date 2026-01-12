import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.85, green: 0.93, blue: 1.0),
                Color(red: 0.96, green: 0.96, blue: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
