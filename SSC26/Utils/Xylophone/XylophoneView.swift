import SwiftUI

struct XylophoneView: View {
    var onPlayNote: (String) -> Void
    let tileHeights: [CGFloat] = [580, 540, 500, 460, 420, 380, 340, 300]
    
    var body: some View {
        // Xylophone with wood sticks
        ZStack {
            // Top wood stick
            Rectangle()
                .fill(Color(red: 0.90, green: 0.75, blue: 0.55))
                .cornerRadius(12)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .offset(y: -tileHeights.first! / 2 + 100)
                .rotationEffect(.degrees(7))
            
            // Bottom wood stick
            Rectangle()
                .fill(Color(red: 0.90, green: 0.75, blue: 0.55))
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .offset(y: tileHeights.last! / 2 + 40)
                .rotationEffect(.degrees(-7))
            
            // Tiles
            HStack(spacing: 10) {
                XylophoneTileView(note: "C", color: .red, height: tileHeights[0]) {
                    SoundPlayer.shared.play(note: "C")
                    onPlayNote("C")
                }
                XylophoneTileView(note: "D", color: .orange, height: tileHeights[1]) {
                    SoundPlayer.shared.play(note: "D")
                    onPlayNote("D")
                }
                XylophoneTileView(note: "E", color: .yellow, height: tileHeights[2]) {
                    SoundPlayer.shared.play(note: "E")
                    onPlayNote("E")
                }
                XylophoneTileView(note: "F", color: .green, height: tileHeights[3]) {
                    SoundPlayer.shared.play(note: "F")
                    onPlayNote("F")
                }
                XylophoneTileView(note: "G", color: .teal, height: tileHeights[4]) {
                    SoundPlayer.shared.play(note: "G")
                    onPlayNote("G")
                }
                XylophoneTileView(note: "A", color: .blue, height: tileHeights[5]) {
                    SoundPlayer.shared.play(note: "A")
                    onPlayNote("A")
                }
                XylophoneTileView(note: "B", color: .indigo, height: tileHeights[6]) {
                    SoundPlayer.shared.play(note: "B")
                    onPlayNote("B")
                }
                XylophoneTileView(note: "C", color: .purple, height: tileHeights[7]) {
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

