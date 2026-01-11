import SwiftUI

struct GuidedSong: Identifiable {
    let id = UUID()
    let title: String
    let notes: [String]
    let colors: [Color]
    let difficulty: Int // 1–3 stars
}

struct GuidedSongsView: View {
    
    let guidedSongs: [GuidedSong] = [
        GuidedSong(
            title: "First Melody",
            notes: ["C", "E", "G"],
            colors: [.red, .yellow, .teal],
            difficulty: 1
        ),
        GuidedSong(
            title: "Rising Tune",
            notes: ["C", "D", "E", "F", "G"],
            colors: [.red, .orange, .yellow, .green, .teal],
            difficulty: 2
        ),
        GuidedSong(
            title: "Full Scale",
            notes: ["C", "D", "E", "F", "G", "A", "B", "C"],
            colors: [.red, .orange, .yellow, .green, .teal, .blue, .indigo, .purple],
            difficulty: 3
        )
    ]


    @State private var selectedSong: GuidedSong? = nil
    

    var body: some View {
        ZStack {
            BackgroundGradient()
                .ignoresSafeArea()

            if let song = selectedSong {
                // Placeholder for song player detail
                VStack(spacing: 16) {
                    Text("Playing: \(song.title)")
                        .font(.title2).bold()
                    Button("Close") {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            selectedSong = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Simple header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Guided Songs")
                                .font(.largeTitle).bold()
                            Text("Pick a melody to start")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 4)

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
                    }
                    .padding(.horizontal, 24)
                    .padding(.top)
                    .padding(.bottom, 24)
                }
                .transition(.opacity)
            }
        }
        .navigationTitle("Guided Songs")
    }
}

#Preview {
    GuidedSongsView()
}
