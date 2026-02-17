import SwiftUI

struct XylophoneView: View {
    var onPlayNote: (String) -> Void
    var pressedTileIndex: Int? = nil
    var tileHeights: [CGFloat] = [580, 540, 500, 460, 420, 380, 340, 300]
    
    var body: some View {
        // Xylophone with wood sticks
        ZStack {
            // Top wood stick - positioned relative to the tallest tile
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.70, blue: 0.50),
                            Color(red: 0.90, green: 0.75, blue: 0.55),
                            Color(red: 0.85, green: 0.70, blue: 0.50)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .offset(y: -tileHeights.first! / 2 + (tileHeights.first! * 0.17))
                .rotationEffect(.degrees(7))
            
            // Bottom wood stick - positioned relative to the shortest tile
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.70, blue: 0.50),
                            Color(red: 0.90, green: 0.75, blue: 0.55),
                            Color(red: 0.85, green: 0.70, blue: 0.50)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .offset(y: tileHeights.last! / 2 + (tileHeights.last! * 0.13))
                .rotationEffect(.degrees(-7))
            
            // Tiles
            HStack(spacing: 10) {
                XylophoneTileView(note: "C", color: .red, height: tileHeights[0], isExternallyPressed: pressedTileIndex == 0) {
                    SoundPlayer.shared.play(note: "C")
                    onPlayNote("C")
                }
                XylophoneTileView(note: "D", color: .orange, height: tileHeights[1], isExternallyPressed: pressedTileIndex == 1) {
                    SoundPlayer.shared.play(note: "D")
                    onPlayNote("D")
                }
                XylophoneTileView(note: "E", color: .yellow, height: tileHeights[2], isExternallyPressed: pressedTileIndex == 2) {
                    SoundPlayer.shared.play(note: "E")
                    onPlayNote("E")
                }
                XylophoneTileView(note: "F", color: .green, height: tileHeights[3], isExternallyPressed: pressedTileIndex == 3) {
                    SoundPlayer.shared.play(note: "F")
                    onPlayNote("F")
                }
                XylophoneTileView(note: "G", color: .teal, height: tileHeights[4], isExternallyPressed: pressedTileIndex == 4) {
                    SoundPlayer.shared.play(note: "G")
                    onPlayNote("G")
                }
                XylophoneTileView(note: "A", color: .blue, height: tileHeights[5], isExternallyPressed: pressedTileIndex == 5) {
                    SoundPlayer.shared.play(note: "A")
                    onPlayNote("A")
                }
                XylophoneTileView(note: "B", color: .indigo, height: tileHeights[6], isExternallyPressed: pressedTileIndex == 6) {
                    SoundPlayer.shared.play(note: "B")
                    onPlayNote("B")
                }
                XylophoneTileView(note: "C", color: .purple, height: tileHeights[7], isExternallyPressed: pressedTileIndex == 7) {
                    SoundPlayer.shared.play(note: "C_H")
                    onPlayNote("C_H")
                }
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    XylophoneView(onPlayNote: { note in
        print("Playing note: \(note)")
    })
}

