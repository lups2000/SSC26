import SwiftUI

struct MusicExperienceView: View {
    
    let songTitle: String
    let songNotes: [String]
    
    // Mapping from note character to SheetNote (pitch relative to staff and color)
    private let noteMap: [String: (pitch: CGFloat, color: Color)] = [
        "C": (7, .red),
        "D": (6, .orange),
        "E": (5, .yellow),
        "F": (4, .green),
        "G": (3, .teal),
        "A": (2, .blue),
        "B": (1, .indigo),
        "C_H": (0, .purple)
    ]

    private var sheetNotes: [SheetNote] {
        songNotes.compactMap { key in
            let upper = key.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if let mapped = noteMap[upper] {
                return SheetNote(pitch: mapped.pitch, color: mapped.color)
            } else {
                return nil
            }
        }
    }

    var body: some View {
        ZStack {
            BackgroundGradient()

            VStack(spacing: 10) {

                MusicSheetView(notes: sheetNotes, title: songTitle)
                    //.padding(.top, 40)

                Spacer()
                
                XylophoneView()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Free Play")
    }
}

#Preview {
    MusicExperienceView(songTitle: "Free Play", songNotes: ["C", "D", "A"])
}
