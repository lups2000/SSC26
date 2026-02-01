import SwiftUI

struct GuideView: View {
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                Text("1. Position your iPad so the camera sees your hand.\n2. Use your index finger to play the xylophone bars.\n3. Try the free play mode for fun!")
                    .multilineTextAlignment(.leading)
                    .padding()
            }
        }
        .navigationTitle("Guide")
    }
}

#Preview {
    GuideView()
}
