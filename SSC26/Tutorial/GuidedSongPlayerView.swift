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
                color: baseColor,
                isTarget: isTarget
            )
            notes.append(sheetNote)
        }

        return notes
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
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("Progress")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(engine.currentIndex)/\(engine.song.notes.count)")
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(.thinMaterial)
                    )
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.05)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .frame(height: 10)

                // Progress fill
                GeometryReader { proxy in
                    let total = max(1, engine.song.notes.count)
                    let progress = CGFloat(engine.currentIndex) / CGFloat(total)
                    let width = proxy.size.width * progress

                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color.blue.opacity(0.9),
                                Color.purple.opacity(0.9)
                            ], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: width, height: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.white.opacity(0.25))
                                .blur(radius: 1)
                                .mask(
                                    LinearGradient(colors: [Color.white.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom)
                                )
                        )
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: engine.currentIndex)
                }
                .frame(height: 10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        GuidedSongPlayerView(song: GuidedSong(title: "First Melody", notes: ["C","E","G","A","G","C_H","C", "C","E","G","A","G","E","C"], difficulty: 1))
    }
}
