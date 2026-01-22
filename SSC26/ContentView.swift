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
                    NavigationLink {
                        TutorialView()
                    } label: {
                        Label("Guide", systemImage: "book.fill")
                    }

                    NavigationLink {
                        GuidedSongsView()
                    } label: {
                        Label("Practice", systemImage: "music.note.list")
                    }

                    NavigationLink {
                        XylophoneView(onPlayNote: { _ in print("ciao") })
                    } label: {
                        Label("Play XyloFingers", systemImage: "hand.point.up.fill")
                    }
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
