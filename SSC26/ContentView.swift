import SwiftUI

struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
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
                    FreePlayView(columnVisibility: $columnVisibility)
                } label: {
                    Label("Free Play", systemImage: "hand.pinch.fill")
                }
            }
            .navigationTitle("XyloFingers")
        } detail: {
            GuideView()
        }
    }
}

#Preview {
    ContentView()
}
