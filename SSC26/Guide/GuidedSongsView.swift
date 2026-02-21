import SwiftUI

struct GuidedSong: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let notes: [String]
    let difficulty: Int
}

struct GuidedSongsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var columnVisibility: NavigationSplitViewVisibility

    let guidedSongs: [GuidedSong] = [
        // --- LEVEL 1 ---
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

        // --- LEVEL 2 ---
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

        // --- LEVEL 3 ---
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

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            BackgroundGradient()

            if let song = selectedSong {
                GuidedSongPlayerView(song: song, columnVisibility: $columnVisibility) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        selectedSong = nil
                    }
                }
                .transition(.opacity) // Simplified transition for better performance
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        heroSection
                        
                        ForEach([1, 2, 3], id: \.self) { level in
                            levelSection(level)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .navigationTitle("Practice")
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedSong)
    }

    // MARK: - Hero Section
    
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: colorScheme == .dark ? 
                                    [.purple.opacity(0.4), .blue.opacity(0.4)] :
                                    [.purple.opacity(0.2), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "music.note.list")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: colorScheme == .dark ?
                                    [.purple.opacity(0.9), .blue.opacity(0.9)] :
                                    [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Learn Through Play")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(guidedSongs.count) songs across 3 levels")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Follow along with guided melodies to master the xylophone. Each song lights up the notes for you to play!")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? 
                    Color(white: 0.15).opacity(0.8) : 
                    Color.white.opacity(0.8)
                )
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ?
                        Color.white.opacity(0.1) :
                        Color.white.opacity(0.2),
                    lineWidth: 1
                )
        }
    }

    // MARK: - Level Section

    @ViewBuilder
    private func levelSection(_ level: Int) -> some View {
        let songsForLevel = guidedSongs.filter { $0.difficulty == level }

        if !songsForLevel.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 12) {
                    levelIcon(level)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(levelTitle(level))
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text(levelDescription(level))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(levelTitle(level)). \(levelDescription(level))")

                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(songsForLevel) { song in
                        SongCardView(song: song) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                selectedSong = song
                            }
                        }
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func levelIcon(_ level: Int) -> some View {
        ZStack {
            Circle()
                .fill(levelColor(level).opacity(0.15))
                .frame(width: 44, height: 44)
            
            Text(levelEmoji(level))
                .font(.system(size: 22))
        }
    }
    
    // MARK: - Helper Functions

    private func levelTitle(_ level: Int) -> String {
        switch level {
        case 1: return "Level 1"
        case 2: return "Level 2"
        case 3: return "Level 3"
        default: return "Level \(level)"
        }
    }
    
    private func levelDescription(_ level: Int) -> String {
        switch level {
        case 1: return "Getting Started"
        case 2: return "Learning Songs"
        case 3: return "Challenge Mode"
        default: return "Advanced"
        }
    }
    
    private func levelEmoji(_ level: Int) -> String {
        switch level {
        case 1: return "🌱"
        case 2: return "🎵"
        case 3: return "🚀"
        default: return "🎵"
        }
    }
    
    private func levelColor(_ level: Int) -> Color {
        switch level {
        case 1: return .green
        case 2: return .orange
        case 3: return .red
        default: return .blue
        }
    }
}

#Preview {
    @Previewable @State var visibility: NavigationSplitViewVisibility = .all
    GuidedSongsView(columnVisibility: $visibility)
}
