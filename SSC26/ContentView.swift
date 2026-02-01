import SwiftUI

struct ContentView: View {
    @State private var hasStarted = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        if !hasStarted {
            WelcomeView(startAction: {
                hasStarted = true
            })
        } else {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                List {
                    NavigationLink {
                        GuideView()
                    } label: {
                        Label("Guide", systemImage: "book.fill")
                    }

                    NavigationLink {
                        GuidedSongsView(columnVisibility: $columnVisibility)
                    } label: {
                        Label("Practice", systemImage: "music.note.list")
                    }

                    NavigationLink {
                        FreePlayView()
                    } label: {
                        Label("Play XyloFingers", systemImage: "hand.point.up.fill")
                    }
                }
                .navigationTitle("XyloFingers")
            } detail: {
                GuideView()
            }

        }
    }
}

#Preview {
    ContentView()
}
