import SwiftUI

struct FreePlayView: View {
    /// Holds the converted screen-space finger points reported by CameraViewController.
    /// Index 0 = thumbTip, Index 1 = indexTip (when both are detected).
    @State private var overlayPoints: [CGPoint] = []

    /// Tracks whether the camera session is actually running so we can show a status indicator.
    @State private var isTracking: Bool = false

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

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Camera Feed (behind everything)
                CameraView { points in
                    overlayPoints = points
                    isTracking = !points.isEmpty
                    handlePinch(points)
                }

                // MARK: - Background gradient (semi-transparent so the camera bleeds through)
                BackgroundGradient()

                // MARK: - Xylophone  +  invisible tile-frame readers
                ZStack {
                    XylophoneView(onPlayNote: { _ in })

                    // Invisible overlay that mirrors the exact HStack layout so we can
                    // read each tile's on-screen CGRect.  The spacing (10) and padding
                    // (.horizontal 16) match XylophoneView / XylophoneTileView.
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

                // MARK: - Finger-tip overlay dots
                // CameraViewController returns [thumbTip, indexTip] in that order.
                // We draw a red dot on the index finger tip (index 1) so you can
                // see exactly where the tracker thinks your index finger is.
                ForEach(overlayPoints.indices, id: \.self) { i in
                    let point = overlayPoints[i]
                    Circle()
                        .fill(i == 1 ? Color.red : Color.yellow) // red = index, yellow = thumb
                        .frame(width: 16, height: 16)
                        .position(x: point.x, y: point.y)
                }

                // MARK: - Tracking status badge
                VStack {
                    HStack {
                        Circle()
                            .fill(isTracking ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                        Text(isTracking ? "Tracking Active" : "Tracking Inactive")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)

                    Spacer()
                }
                .padding()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
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
            return
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

/// Collects per-tile CGRects up the view tree so FreePlayView can hit-test against them.
private struct TileFramePreferenceKey: PreferenceKey {
    static let defaultValue: [TileFrameEntry] = []

    static func reduce(value: inout [TileFrameEntry],
                       nextValue: () -> [TileFrameEntry]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    FreePlayView()
}
