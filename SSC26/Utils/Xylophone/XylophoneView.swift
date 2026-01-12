import SwiftUI

struct XylophoneView: View {
    
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
                }
                XylophoneTileView(note: "D", color: .orange, height: tileHeights[1]) {
                    SoundPlayer.shared.play(note: "D")
                }
                XylophoneTileView(note: "E", color: .yellow, height: tileHeights[2]) {
                    SoundPlayer.shared.play(note: "E")
                }
                XylophoneTileView(note: "F", color: .green, height: tileHeights[3]) {
                    SoundPlayer.shared.play(note: "F")
                }
                XylophoneTileView(note: "G", color: .teal, height: tileHeights[4]) {
                    SoundPlayer.shared.play(note: "G")
                }
                XylophoneTileView(note: "A", color: .blue, height: tileHeights[5]) {
                    SoundPlayer.shared.play(note: "A")
                }
                XylophoneTileView(note: "B", color: .indigo, height: tileHeights[6]) {
                    SoundPlayer.shared.play(note: "B")
                }
                XylophoneTileView(note: "C", color: .purple, height: tileHeights[7]) {
                    SoundPlayer.shared.play(note: "C_H")
                }
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    XylophoneView()
}
