import SwiftUI

struct GuidedSong: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let notes: [String]
    let difficulty: Int
}

struct GuidedSongsView: View {
    
    let guidedSongs: [GuidedSong] = [
        // --- LEVEL 1 (Super Easy) ---
        GuidedSong(
            title: "Mary Had a Little Lamb",
            description: "Follow the little lamb! A great way to start with just 3 simple notes.",
            notes: ["E", "D", "C", "D", "E", "E", "E", "D", "D", "D", "E", "G", "G"],
            difficulty: 1
        ),
        GuidedSong(
            title: "Hot Cross Buns",
            description: "Tap-tap-tap! A yummy song that helps you practice double-tapping the keys.",
            notes: ["E", "D", "C", "E", "D", "C", "C", "C", "C", "C", "D", "D", "D", "D", "E", "D", "C"],
            difficulty: 1
        ),
        
        // --- LEVEL 2 (Fun Learning) ---
        GuidedSong(
            title: "Twinkle Twinkle Little Star",
            description: "Time to shine! This lullaby helps you jump across the colors like a star.",
            notes: ["C", "C", "G", "G", "A", "A", "G", "F", "F", "E", "E", "D", "D", "C"],
            difficulty: 2
        ),
        GuidedSong(
            title: "Ode to Joy",
            description: "A happy, famous tune! See if you can play it perfectly one note at a time.",
            notes: ["E", "E", "F", "G", "G", "F", "E", "D", "C", "C", "D", "E", "E", "D", "D"],
            difficulty: 2
        ),
        
        // --- LEVEL 3 (Xylophone Hero) ---
        GuidedSong(
            title: "Joy to the World",
            description: "Slide down the rainbow! Start from the top and play all the way to the bottom.",
            notes: ["C_H", "B", "A", "G", "F", "E", "D", "C", "G", "A", "A", "B", "C_H"],
            difficulty: 3
        ),
        GuidedSong(
            title: "The Can-Can",
            description: "The speed challenge! Can you keep up with the fast and bouncy notes?",
            notes: ["C", "C", "E", "D", "C", "G", "G", "A", "G", "C_H", "C_H", "B", "A", "G"],
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
