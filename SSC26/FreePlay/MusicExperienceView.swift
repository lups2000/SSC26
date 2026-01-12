import SwiftUI

struct MusicExperienceView: View {

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

                MusicSheetView(notes: sheetNotes)
                    .padding(.top, 20)

                Spacer()
                
                XylophoneView()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Free Play")
    }
}

#Preview {
    MusicExperienceView()
}
