import SwiftUI
import Combine

struct GuidedSongPlayerView: View {
    @State private var engine: GuidedSongEngine

    init(song: GuidedSong, windowSize: Int = 5) {
        _engine = State(
            wrappedValue: GuidedSongEngine(song: song, windowSize: windowSize)
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
        engine.visibleWindow.enumerated().map { _, item in
            let note = item.note
            let idx = item.index
            let isTarget = (idx == engine.currentIndex)
            let isPast = (idx ?? Int.max) < engine.currentIndex
            let baseColor: Color = {
                if let idx = idx, !engine.song.colors.isEmpty {
                    return engine.song.colors[idx % engine.song.colors.count]
                } else {
                    return .blue
                }
            }()
            return SheetNote(
                pitch: pitch(for: note),
                color: adjustedColor(base: baseColor, isTarget: isTarget, isPast: isPast)
            )
        }
    }
    
    private func adjustedColor(base: Color, isTarget: Bool, isPast: Bool) -> Color {
        if isTarget {
            return engine.lastInputWasCorrect == false ? .red : base
        }
        if isPast {
            return base.opacity(0.5)
        }
        return base
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
        default: return 0
        }
    }

    private var notesStrip: some View {
        MusicSheetView(
            notes: sheetNotes(),
            title: engine.song.title
        )
        .frame(height: 260)
        .animation(.spring(response: 0.35, dampingFraction: 0.8),
                   value: engine.currentIndex)
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
        GuidedSongPlayerView(song: GuidedSong(title: "First Melody", notes: ["C","E","G","A","G","E","C"], colors: [.red,.yellow,.teal], difficulty: 1))
    }
}
