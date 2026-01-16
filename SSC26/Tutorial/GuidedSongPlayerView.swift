import SwiftUI
import Combine

struct GuidedSongPlayerView: View {
    @State private var engine: GuidedSongEngine

    init(song: GuidedSong) {
        _engine = State(
            wrappedValue: GuidedSongEngine(song: song)
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            MusicSheetView(
                notes: sheetNotes(),
                title: engine.song.title
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.8),
                       value: engine.currentIndex)
            progress
            XylophoneView(onPlayNote: { note in
                engine.handleInput(note: note)
            })
        }
        .padding()
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: engine.currentIndex)
        .animation(.easeInOut(duration: 0.2), value: engine.lastInputWasCorrect)
        .background(
            LinearGradient(colors: [.blue.opacity(0.06), .purple.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
    
    private func sheetNotes() -> [SheetNote] {
        let windowSize = 6
        let chunkStart = (engine.currentIndex / windowSize) * windowSize
        let chunkEnd = min(chunkStart + windowSize, engine.song.notes.count)

        var notes: [SheetNote] = []

        for idx in chunkStart..<chunkEnd {
            let note = engine.song.notes[idx]
            let isTarget = (idx == engine.currentIndex)
            let baseColor = getColorNote(for: note)
            let sheetNote = SheetNote(
                pitch: pitch(for: note),
                color: adjustedColor(base: baseColor, isTarget: isTarget)
            )
            notes.append(sheetNote)
        }

        return notes
    }
    
    private func adjustedColor(base: Color, isTarget: Bool) -> Color {
        if isTarget {
            return base
        }
        return base.opacity(0.3)
    }
    
    private func pitch(for note: String) -> CGFloat {
        switch note {
            case "C": return 6
            case "D": return 5
            case "E": return 4
            case "F": return 3
            case "G": return 2
            case "A": return 1
            case "B": return 0
            case "C_H": return -1
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

    private var progress: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(engine.currentIndex)/\(engine.song.notes.count)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: Double(engine.currentIndex), total: Double(engine.song.notes.count))
                .progressViewStyle(.linear)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
        )
    }
}

#Preview {
    NavigationStack {
        GuidedSongPlayerView(song: GuidedSong(title: "First Melody", notes: ["C","E","G","A","G","C_H","C", "C","E","G","A","G","E","C"], difficulty: 1))
    }
}
