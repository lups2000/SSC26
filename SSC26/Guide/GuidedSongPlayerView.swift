import SwiftUI
import Combine

struct GuidedSongPlayerView: View {
    @State private var engine: GuidedSongEngine
    let onBack: () -> Void
    
    // MARK: - Hand Tracking
    
    /// Manages all hand tracking state and pinch detection logic
    @State private var handTrackingManager = HandTrackingManager()
    
    // MARK: - Performance Optimization
    
    /// Delays camera initialization until the view is fully presented
    @State private var shouldInitializeCamera = false

    init(song: GuidedSong, onBack: @escaping () -> Void) {
        _engine = State(wrappedValue: GuidedSongEngine(song: song))
        self.onBack = onBack
    }

    var body: some View {
        // Adaptive tile heights based on screen size (computed once)
        let adaptiveTileHeights: [CGFloat] = UIScreen.main.bounds.height < 1000 
            ? [470, 440, 410, 380, 340, 310, 280, 240]  // 11-inch iPad
            : [580, 540, 500, 460, 420, 380, 340, 300]  // 13-inch iPad
        
        GeometryReader { geo in
            ZStack {
                // MARK: - Camera Feed (behind everything) - LAZY LOADED
                if handTrackingManager.settings.isHandTrackingEnabled && shouldInitializeCamera {
                    CameraView { points in
                        handTrackingManager.handleCameraUpdate(points)
                    }
                }
                
                // MARK: - Background gradient (semi-transparent so the camera bleeds through)
                BackgroundGradient()
                
                // MARK: - Main Content
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
                    .animation(.spring(response: 0.35, dampingFraction: 0.8),
                               value: engine.currentIndex)
                    
                    // MARK: - Xylophone with tile frame tracking
                    XylophoneWithTracking(manager: handTrackingManager, tileHeights: adaptiveTileHeights) { note in
                        engine.handleInput(note: note)
                    }
                }
                .padding()
                
                // MARK: - Hand tracking controls (on top of everything)
                HandTrackingControls(manager: handTrackingManager)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
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
        .task {
            // Hook up the hand tracking manager to the game engine
            handTrackingManager.onNoteTriggered = { note in
                engine.handleInput(note: note)
            }
            
            // Delay camera initialization to allow view to render first
            // This dramatically improves perceived performance
            try? await Task.sleep(for: .milliseconds(300))
            shouldInitializeCamera = true
        }
    }
    
    // MARK: - Helper Methods
    
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

