import SwiftUI

/// A wrapper around XylophoneView that includes invisible tile frame tracking.
/// This allows the HandTrackingManager to detect which tile was pinched.
struct XylophoneWithTracking: View {
    let manager: HandTrackingManager
    let onPlayNote: (String) -> Void
    var tileHeights: [CGFloat] = [580, 540, 500, 460, 420, 380, 340, 300]
    
    var body: some View {
        ZStack {
            XylophoneView(onPlayNote: onPlayNote, pressedTileIndex: manager.pressedTileIndex, tileHeights: tileHeights)
            
            // Invisible overlay that mirrors the exact HStack layout so we can
            // read each tile's on-screen CGRect. The spacing (10) and padding
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
            manager.updateTileFrames(values)
        }
    }
}

#Preview {
    XylophoneWithTracking(manager: HandTrackingManager()) { note in
        print("Note played: \(note)")
    }
}
