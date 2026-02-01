import SwiftUI

struct FreePlayView: View {
    var body: some View {
        ZStack {
            BackgroundGradient()
            XylophoneView(onPlayNote: { _ in  })
        }
    }
}

#Preview {
    FreePlayView()
}
