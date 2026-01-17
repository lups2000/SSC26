import SwiftUI

struct GuidedSong: Identifiable {
    let id = UUID()
    let title: String
    let notes: [String]
    let difficulty: Int
}

struct GuidedSongsView: View {
    
    let guidedSongs: [GuidedSong] = [
        GuidedSong(
            title: "First Melody",
            notes: ["C", "E", "G"],
            difficulty: 1
        ),
        GuidedSong(
            title: "Rising Tune",
            notes: ["C", "D", "E", "F", "G"],
            difficulty: 2
        ),
        GuidedSong(
            title: "Full Scale",
            notes: ["C", "D", "E", "F", "G", "A", "B", "C_H"],
            difficulty: 3
        )
    ]


    @State private var selectedSong: GuidedSong? = nil
    

    var body: some View {
        ZStack {
            BackgroundGradient()

            if let song = selectedSong {
                GuidedSongPlayerView(song: song)
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    // Simple header
                    Text("Pick a melody to start")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    let gridColumns = [
                        GridItem(.flexible(), spacing: 18),
                        GridItem(.flexible(), spacing: 18)
                    ]
                    LazyVGrid(columns: gridColumns, alignment: .center, spacing: 18) {
                        ForEach(guidedSongs) { song in
                            SongCardView(song: song) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    selectedSong = song
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("Guided Songs")
    }
}

#Preview {
    GuidedSongsView()
}
