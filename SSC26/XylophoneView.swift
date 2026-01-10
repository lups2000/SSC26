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

    var body: some View {
        ZStack {
            BackgroundGradient()

            VStack(spacing: 40) {

                // Music sheet at the top
                MusicSheetView(notes: sheetNotes)
                    .padding(.top, 20)

                Spacer()

                // Xylophone tiles at the bottom
                HStack(spacing: 10) {
                    XylophoneTile(note: "C", color: .red, height: 580)
                    XylophoneTile(note: "D", color: .orange, height: 540)
                    XylophoneTile(note: "E", color: .yellow, height: 500)
                    XylophoneTile(note: "F", color: .green, height: 460)
                    XylophoneTile(note: "G", color: .teal, height: 420)
                    XylophoneTile(note: "A", color: .blue, height: 380)
                    XylophoneTile(note: "B", color: .indigo, height: 340)
                    XylophoneTile(note: "C", color: .purple, height: 300)
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
