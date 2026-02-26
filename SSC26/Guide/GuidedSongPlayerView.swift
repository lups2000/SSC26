import SwiftUI
import Combine

struct GuidedSongPlayerView: View {
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State private var engine: GuidedSongEngine
    let onBack: () -> Void
    
    // MARK: - Hand Tracking
    
    /// Manages all hand tracking state and pinch detection logic
    @State private var handTrackingManager = HandTrackingManager()
    
    // MARK: - Performance Optimization
    
    /// Delays camera initialization until the view is fully presented
    @State private var shouldInitializeCamera = false

    init(song: GuidedSong, columnVisibility: Binding<NavigationSplitViewVisibility>, onBack: @escaping () -> Void) {
        _engine = State(wrappedValue: GuidedSongEngine(song: song))
        _columnVisibility = columnVisibility
        self.onBack = onBack
    }

    var body: some View {
        // Adaptive tile heights based on screen size (computed once)
        let isSmallScreen = UIScreen.main.bounds.height < 1000
        let adaptiveTileHeights: [CGFloat] = isSmallScreen
            ? [470, 440, 410, 380, 340, 310, 280, 240]  // 11-inch iPad
            : [580, 540, 500, 460, 420, 380, 340, 300]  // 13-inch iPad
        
        GeometryReader { geo in
            ZStack {
                // MARK: - Camera Feed (behind everything) - LAZY LOADED
                if shouldInitializeCamera {
                    CameraView { points in
                        handTrackingManager.handleCameraUpdate(points)
                    }
                    .task {
                        // Give extra time for camera to initialize without blocking
                        try? await Task.sleep(for: .milliseconds(100))
                    }
                }
                
                // MARK: - Classroom Wall Background (semi-transparent so the camera bleeds through)
                ClassroomWallBackground()
                
                // MARK: - Main Content
                VStack(spacing: 8) {
                    // Chalkboard and control panel side by side
                    HStack(alignment: .center, spacing: 20) {
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
                        
                        // Clock and hand tracking control panel stacked vertically
                        VStack(spacing: 16) {
                            // Decorative classroom clock
                            ClassroomClockView()
                                .frame(width: 90, height: 90)
                            
                            // Hand tracking control panel
                            HandTrackingControlPanel(
                                isEnabled: handTrackingManager.settings.isHandTrackingEnabled,
                                isTracking: handTrackingManager.isTracking,
                                onToggle: {
                                    // Toggle the setting immediately (feels responsive)
                                    await handTrackingManager.settings.toggleHandTracking()
                                    
                                    if !handTrackingManager.settings.isHandTrackingEnabled {
                                        // Turning OFF - immediate cleanup
                                        shouldInitializeCamera = false
                                        handTrackingManager.resetTracking()
                                    } else {
                                        // Turning ON - delayed camera init to prevent freeze
                                        // Do this in a detached task to not block the button
                                        Task.detached { @MainActor in
                                            // Small delay to let UI update first
                                            try? await Task.sleep(for: .milliseconds(100))
                                            shouldInitializeCamera = true
                                        }
                                    }
                                }
                            )
                        }
                    
                    }
                    
                    // MARK: - Xylophone with tile frame tracking
                    XylophoneWithTracking(
                        manager: handTrackingManager,
                        onPlayNote: { note in
                            engine.handleInput(note: note)
                        },
                        tileHeights: adaptiveTileHeights,
                        isSmallScreen: isSmallScreen
                    )
                    .padding(.top, 18)
                    .padding(.horizontal, 20)
                }
                .padding()
                
                // MARK: - Hand tracking visual overlays (finger dots only)
                HandTrackingVisualsOnly(manager: handTrackingManager)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
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
            columnVisibility = .detailOnly
            
            // Hook up the hand tracking manager to the game engine
            handTrackingManager.onNoteTriggered = { note in
                engine.handleInput(note: note)
            }
            
            // If hand tracking is already enabled (from a previous session),
            // initialize camera after view is settled
            if handTrackingManager.settings.isHandTrackingEnabled {
                try? await Task.sleep(for: .milliseconds(500))
                shouldInitializeCamera = true
            }
        }
        .onDisappear {
            // Clean up camera when leaving
            shouldInitializeCamera = false
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
    @Previewable @State var visibility: NavigationSplitViewVisibility = .detailOnly
    
    NavigationStack {
        GuidedSongPlayerView(
            song: GuidedSong(
                title: "Twinkle Twinkle Little Star",
                description: "Time to shine! This lullaby helps you jump across the colors like a star.",
                notes: ["C", "C", "G", "G", "A", "A", "G", "F", "F", "E", "E", "D", "D", "C"],
                difficulty: 2
            ),
            columnVisibility: $visibility,
            onBack: {
                print("Back tapped")
            }
        )
    }
}

