import SwiftUI

struct GuidedSongsView: View {

    @State private var selectedSong: GuidedSong? = nil

    var body: some View {
        ZStack {
            BackgroundGradient()

            if let song = selectedSong {
                // Song player view (reuse your Xylophone + MusicSheet)
                GuidedSongPlayView(song: song) {
                    selectedSong = nil
                }
            } else {
                VStack(spacing: 24) {

                    Text("Guided Songs")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Choose a melody and play with your hands")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        ForEach(guidedSongs) { song in
                            SongCardView(song: song) {
                                withAnimation(.easeInOut) {
                                    selectedSong = song
                                }
                            }
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Guided Songs")
    }
}

