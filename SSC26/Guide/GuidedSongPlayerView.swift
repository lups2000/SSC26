import SwiftUI
import Combine

struct GuidedSongPlayerView: View {
    @State private var engine: GuidedSongEngine
    let onBack: () -> Void
    
    // MARK: - Hand Tracking State
    
    /// Holds the converted screen-space finger points reported by CameraViewController.
    /// Index 0 = thumbTip, Index 1 = indexTip (when both are detected).
    @State private var overlayPoints: [CGPoint] = []
    
    /// Tracks whether the camera session is actually running so we can show a status indicator.
    @State private var isTracking: Bool = false
    
    /// App settings for hand tracking toggle
    @State private var settings = AppSettings.shared
    
    // MARK: - Pinch Detection State
    
    /// The notes in left-to-right tile order, matching XylophoneView's HStack layout.
    private static let noteOrder: [String] = ["C", "D", "E", "F", "G", "A", "B", "C_H"]
    
    /// On-screen frames of each xylophone tile, keyed by index into `noteOrder`.
    /// Populated at layout time via the invisible GeometryReader overlay.
    @State private var tileFrames: [Int: CGRect] = [:]
    
    /// The distance (in points) between thumb and index tip that counts as a pinch.
    private static let pinchThreshold: CGFloat = 60
    
    /// Prevents retriggering the same note while the fingers stay close together.
    /// Reset to `nil` once the fingers separate past the threshold.
    @State private var lastPinchNote: String? = nil

    init(song: GuidedSong, onBack: @escaping () -> Void) {
        _engine = State(wrappedValue: GuidedSongEngine(song: song))
        self.onBack = onBack
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Camera Feed (behind everything) - Only show if hand tracking is enabled
                if settings.isHandTrackingEnabled {
                    CameraView { points in
                        overlayPoints = points
                        isTracking = !points.isEmpty
                        handlePinch(points)
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
                    .frame(width: 650)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8),
                               value: engine.currentIndex)
                    
                    // MARK: - Xylophone + invisible tile-frame readers
                    ZStack {
                        XylophoneView(onPlayNote: { note in
                            engine.handleInput(note: note)
                        })
                        
                        // Invisible overlay that mirrors the exact HStack layout so we can
                        // read each tile's on-screen CGRect.
                        HStack(spacing: 10) {
                            ForEach(0..<8) { i in
                                Color.clear
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        GeometryReader { tileGeo in
                                            Color.clear.preference(
                                                key: TileFramePreferenceKey.self,
                                                value: [TileFrameEntry(index: i, frame: tileGeo.frame(in: .global))]
                                            )
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .onPreferenceChange(TileFramePreferenceKey.self) { values in
                        for entry in values {
                            tileFrames[entry.index] = entry.frame
                        }
                    }
                }
                .padding()
                
                // MARK: - Finger-tip overlay dots
                if settings.isHandTrackingEnabled {
                    ForEach(overlayPoints.indices, id: \.self) { i in
                        let point = overlayPoints[i]
                        Circle()
                            .fill(i == 1 ? Color.red : Color.yellow) // red = index, yellow = thumb
                            .frame(width: 16, height: 16)
                            .position(x: point.x, y: point.y)
                    }
                }
                
                // MARK: - Control overlay (top-right)
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 10) {
                            // Hand tracking toggle button
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    settings.isHandTrackingEnabled.toggle()
                                    if !settings.isHandTrackingEnabled {
                                        isTracking = false
                                        overlayPoints = []
                                    }
                                }
                            }) {
                                VStack(spacing: 8) {
                                    // Icon
                                    ZStack {
                                        Circle()
                                            .fill(settings.isHandTrackingEnabled ?
                                                LinearGradient(colors: [.blue.opacity(0.3), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom) :
                                                LinearGradient(colors: [.orange.opacity(0.3), .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                                            )
                                            .frame(width: 56, height: 56)
                                        
                                        Image(systemName: settings.isHandTrackingEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundStyle(settings.isHandTrackingEnabled ? .blue : .orange)
                                    }
                                    
                                    // Label
                                    VStack(spacing: 2) {
                                        Text(settings.isHandTrackingEnabled ? "Hand Tracking" : "Touch Mode")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        
                                        Text(settings.isHandTrackingEnabled ? "TAP TO DISABLE" : "TAP TO ENABLE")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(16)
                                .background {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                                }
                            }
                            .buttonStyle(.plain)
                            
                            // Tracking status badge (only show when hand tracking is enabled)
                            if settings.isHandTrackingEnabled {
                                HStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(isTracking ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                            .frame(width: 20, height: 20)
                                        
                                        Circle()
                                            .fill(isTracking ? Color.green : Color.red)
                                            .frame(width: 10, height: 10)
                                    }
                                    
                                    Text(isTracking ? "Active" : "Inactive")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background {
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                                }
                                .overlay {
                                    Capsule()
                                        .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.trailing, 10)
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
    }
    
    // MARK: - Pinch Handling
    
    /// Called every time the camera delivers a new set of finger points.
    /// Detects a pinch (thumb + index close together) and plays the note
    /// whose tile the midpoint lands on.
    private func handlePinch(_ points: [CGPoint]) {
        // Need both thumb (0) and index (1).
        guard points.count >= 2 else {
            lastPinchNote = nil   // fingers separated or lost — allow re-trigger
            return
        }
        
        let thumb = points[0]
        let index = points[1]
        let distance = hypot(thumb.x - index.x, thumb.y - index.y)
        
        guard distance < Self.pinchThreshold else {
            lastPinchNote = nil   // fingers separated — reset so next pinch fires
            return
        }
        
        // Midpoint of the two fingertips is where we hit-test.
        let midpoint = CGPoint(x: (thumb.x + index.x) / 2,
                               y: (thumb.y + index.y) / 2)
        
        // Find which tile the midpoint falls inside.
        for (i, frame) in tileFrames {
            guard frame.contains(midpoint) else { continue }
            
            let note = Self.noteOrder[i]
            
            // Suppress repeat while fingers stay pinched on the same tile.
            guard note != lastPinchNote else { return }
            
            lastPinchNote = note
            SoundPlayer.shared.play(note: note)
            engine.handleInput(note: note)
            return
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

// MARK: - Preference Key for Tile Frames

/// A single tile's index and on-screen frame. Declared as a named struct so it
/// can conform to `Equatable`, which `onPreferenceChange` requires.
private struct TileFrameEntry: Equatable {
    let index: Int
    let frame: CGRect
}

/// Collects per-tile CGRects up the view tree so GuidedSongPlayerView can hit-test against them.
private struct TileFramePreferenceKey: PreferenceKey {
    static let defaultValue: [TileFrameEntry] = []
    
    static func reduce(value: inout [TileFrameEntry],
                       nextValue: () -> [TileFrameEntry]) {
        value.append(contentsOf: nextValue())
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

