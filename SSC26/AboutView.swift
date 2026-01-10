import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About This App")
                .font(.largeTitle)
                .bold()
            Text("This interactive xylophone lets you play using your fingers and hand-tracking!")
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
