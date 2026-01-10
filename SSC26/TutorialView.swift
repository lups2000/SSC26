import SwiftUI

struct TutorialView: View {
    var body: some View {
        VStack {
            Text("Tutorial")
                .font(.largeTitle)
                .bold()
            Text("1. Position your iPad so the camera sees your hand.\n2. Use your index finger to play the xylophone bars.\n3. Try the free play mode for fun!")
                .multilineTextAlignment(.leading)
                .padding()
        }
        .navigationTitle("Tutorial")
    }
}

#Preview {
    TutorialView()
}
