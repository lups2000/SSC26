import SwiftUI
import Combine

struct GuidedSongPlayerView: View {
    @State private var engine: GuidedSongEngine
    let onBack: () -> Void

    init(song: GuidedSong, onBack: @escaping () -> Void) {
        _engine = State(wrappedValue: GuidedSongEngine(song: song))
        self.onBack = onBack
    }

    var body: some View {
        VStack(spacing: 16) {
            MusicSheetView(
                notes: sheetNotes(),
                title: engine.song.title,
                isCorrect: engine.lastInputWasCorrect ?? true,
                progress: Double(engine.currentIndex) / Double(max(1, engine.song.notes.count)),
                onRestart: {
                    engine.reset()
                },
                onClose: onBack
            )
            .frame(width: 650)
            .animation(.spring(response: 0.35, dampingFraction: 0.8),
                       value: engine.currentIndex)
            
            XylophoneView(onPlayNote: { note in
                engine.handleInput(note: note)
            })
        }
        .padding()
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: engine.currentIndex)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onBack) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        
    }
    
    private func sheetNotes() -> [SheetNote] {
        let windowSize = 5
        let chunkStart = (engine.currentIndex / windowSize) * windowSize
        let chunkEnd = min(chunkStart + windowSize, engine.song.notes.count)

        var notes: [SheetNote] = []

        for idx in chunkStart..<chunkEnd {
            let note = engine.song.notes[idx]
            let isTarget = (idx == engine.currentIndex)
            let baseColor = getColorNote(for: note)
            let sheetNote = SheetNote(
                pitch: pitch(for: note),
                color: baseColor,
                isTarget: isTarget
            )
            notes.append(sheetNote)
        }

        return notes
    }
    
    private func pitch(for note: String) -> CGFloat {
        switch note {
            case "C": return 6.5
            case "D": return 5.4
            case "E": return 4.3
            case "F": return 3.2
            case "G": return 2.1
            case "A": return 1.0
            case "B": return 0.1
            case "C_H": return -0.8
            default: return 0
        }
    }
    
    private func getColorNote(for note: String) -> Color {
        switch note {
            case "C": return .red
            case "D": return .orange
            case "E": return .yellow
            case "F": return .green
            case "G": return .teal
            case "A": return .blue
            case "B": return .indigo
            case "C_H": return .purple
            default: return .red
        }
    }
}

#Preview {
    NavigationStack {
        GuidedSongPlayerView(song: GuidedSong(
            title: "Twinkle Twinkle Little Star",
            description: "Time to shine! This lullaby helps you jump across the colors like a star.",
            notes: ["C", "C", "G", "G", "A", "A", "G", "F", "F", "E", "E", "D", "D", "C"],
            difficulty: 2
        ), onBack: {
            print("Back tapped")
        })
    }
}

