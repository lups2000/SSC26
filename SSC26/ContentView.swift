import SwiftUI

struct ContentView: View {
    @State private var hasStarted = false
    
    var body: some View {
        if !hasStarted {
            WelcomeView(startAction: {
                hasStarted = true
            })
        } else {
            NavigationSplitView {
                List {
                    NavigationLink("Tutorial", destination: TutorialView())
                    NavigationLink("Guided Songs", destination: GuidedSongsView())
                    NavigationLink("Free Play", destination: XylophoneView())
                }
                .navigationTitle("XyloFingers")
            } detail: {
                TutorialView()
            }
        }
    }
}

#Preview {
    ContentView()
}
