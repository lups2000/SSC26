import SwiftUI

struct XylophoneView: View {

    let sheetNotes: [SheetNote] = [
        SheetNote(pitch: 7, color: .red),
        SheetNote(pitch: 6, color: .orange),
        SheetNote(pitch: 5, color: .yellow),
        SheetNote(pitch: 4, color: .green),
        SheetNote(pitch: 3, color: .teal),
        SheetNote(pitch: 2, color: .blue),
        SheetNote(pitch: 1, color: .indigo),
        SheetNote(pitch: 0, color: .purple)
    ]
    
    let tileHeights: [CGFloat] = [580, 540, 500, 460, 420, 380, 340, 300]

    var body: some View {
        ZStack {
            BackgroundGradient()

            VStack(spacing: 40) {

                // Music sheet
                MusicSheetView(notes: sheetNotes)
                    .padding(.top, 20)

                Spacer()

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
                        XylophoneTile(note: "C", color: .red, height: tileHeights[0]) {
                            SoundPlayer.shared.play(note: "C")
                        }
                        XylophoneTile(note: "D", color: .orange, height: tileHeights[1]) {
                            SoundPlayer.shared.play(note: "D")
                        }
                        XylophoneTile(note: "E", color: .yellow, height: tileHeights[2]) {
                            SoundPlayer.shared.play(note: "E")
                        }
                        XylophoneTile(note: "F", color: .green, height: tileHeights[3]) {
                            SoundPlayer.shared.play(note: "F")
                        }
                        XylophoneTile(note: "G", color: .teal, height: tileHeights[4]) {
                            SoundPlayer.shared.play(note: "G")
                        }
                        XylophoneTile(note: "A", color: .blue, height: tileHeights[5]) {
                            SoundPlayer.shared.play(note: "A")
                        }
                        XylophoneTile(note: "B", color: .indigo, height: tileHeights[6]) {
                            SoundPlayer.shared.play(note: "B")
                        }
                        XylophoneTile(note: "C", color: .purple, height: tileHeights[7]) {
                            SoundPlayer.shared.play(note: "C_H")
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Free Play")
    }
}

#Preview {
    XylophoneView()
}
