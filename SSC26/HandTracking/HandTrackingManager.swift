import SwiftUI
import Observation

/// Manages hand tracking state and pinch detection logic for xylophone interaction.
/// This class encapsulates all the hand tracking functionality that was previously
/// duplicated across FreePlayView and GuidedSongPlayerView.
@Observable
final class HandTrackingManager {
    
    // MARK: - Hand Tracking State
    
    /// Holds the converted screen-space finger points reported by CameraViewController.
    /// Index 0 = thumbTip, Index 1 = indexTip (when both are detected).
    var overlayPoints: [CGPoint] = []
    
    /// Tracks whether the camera session is actually running.
    var isTracking: Bool = false
    
    /// App settings for hand tracking toggle (shared singleton)
    var settings = AppSettings.shared
    
    // MARK: - Pinch Detection State
    
    /// The notes in left-to-right tile order, matching XylophoneView's HStack layout.
    private static let noteOrder: [String] = ["C", "D", "E", "F", "G", "A", "B", "C_H"]
    
    /// On-screen frames of each xylophone tile, keyed by index into `noteOrder`.
    /// Populated at layout time via the invisible GeometryReader overlay.
    var tileFrames: [Int: CGRect] = [:]
    
    /// The distance (in points) between thumb and index tip that counts as a pinch.
    private static let pinchThreshold: CGFloat = 60
    
    /// Prevents retriggering the same note while the fingers stay close together.
    /// Reset to `nil` once the fingers separate past the threshold.
    private var lastPinchNote: String? = nil
    
    // MARK: - Callback
    
    /// Called when a note is played via pinch gesture.
    /// Use this to hook into your game logic (e.g., engine.handleInput(note:))
    var onNoteTriggered: ((String) -> Void)?
    
    /// Tracks which tile index should currently show a pressed animation.
    /// Set to the tile index to trigger animation, or nil to clear all animations.
    var pressedTileIndex: Int? = nil
    
    /// The currently active note being played (for visual feedback).
    /// Set when a pinch is detected on a tile, cleared when fingers separate.
    var currentNote: String? = nil
    
    // MARK: - Public Methods
    
    /// Call this from your CameraView's onUpdate closure.
    /// Updates tracking state and handles pinch detection.
    func handleCameraUpdate(_ points: [CGPoint]) {
        overlayPoints = points
        isTracking = !points.isEmpty
        handlePinch(points)
    }
    
    /// Resets the tracking state when hand tracking is disabled.
    func resetTracking() {
        isTracking = false
        overlayPoints = []
        lastPinchNote = nil
        pressedTileIndex = nil
    }
    
    /// Updates tile frames from preference key values.
    func updateTileFrames(_ entries: [TileFrameEntry]) {
        for entry in entries {
            tileFrames[entry.index] = entry.frame
        }
    }
    
    // MARK: - Private Methods
    
    /// Detects a pinch (thumb + index close together) and plays the note
    /// whose tile the midpoint lands on.
    private func handlePinch(_ points: [CGPoint]) {
        // Need both thumb (0) and index (1).
        guard points.count >= 2 else {
            lastPinchNote = nil   // fingers separated or lost — allow re-trigger
            pressedTileIndex = nil // clear tile animation
            currentNote = nil     // clear note feedback
            return
        }
        
        let thumb = points[0]
        let index = points[1]
        let distance = hypot(thumb.x - index.x, thumb.y - index.y)
        
        guard distance < Self.pinchThreshold else {
            lastPinchNote = nil   // fingers separated — reset so next pinch fires
            pressedTileIndex = nil // clear tile animation
            currentNote = nil     // clear note feedback
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
            pressedTileIndex = i // trigger visual animation
            currentNote = note   // expose for visual feedback
            
            // Play the sound
            SoundPlayer.shared.play(note: note)
            
            // Notify callback (for game logic integration)
            onNoteTriggered?(note)
            
            // Clear the animation after a short delay
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(150))
                if pressedTileIndex == i {
                    pressedTileIndex = nil
                }
            }
            return
        }
        
        // If we're pinching but not on any tile, clear the animation
        pressedTileIndex = nil
    }
}

// MARK: - Preference Key for Tile Frames

/// A single tile's index and on-screen frame.
struct TileFrameEntry: Equatable {
    let index: Int
    let frame: CGRect
}

/// Collects per-tile CGRects up the view tree for hit-testing.
struct TileFramePreferenceKey: PreferenceKey {
    static let defaultValue: [TileFrameEntry] = []
    
    static func reduce(value: inout [TileFrameEntry],
                       nextValue: () -> [TileFrameEntry]) {
        value.append(contentsOf: nextValue())
    }
}
