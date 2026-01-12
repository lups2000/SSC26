import SwiftUI

struct SheetNote: Identifiable {
    let id = UUID()
    let pitch: CGFloat
    let color: Color
}

struct MusicSheetView: View {
    let notes: [SheetNote]

    private let lineSpacing: CGFloat = 18
    private let noteSize: CGFloat = 25

    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 16) {
                
                // Treble clef
                Text("𝄞")
                    .font(.system(size: 100))
                    .foregroundColor(.black.opacity(0.8))
                    .offset(y: -10)
                
                ZStack {
                    // Staff lines
                    VStack(spacing: lineSpacing) {
                        ForEach(0..<5) { _ in
                            Rectangle()
                                .fill(Color.black.opacity(0.6))
                                .frame(height: 1)
                        }
                    }

                    // Notes
                    HStack(spacing: 50) {
                        ForEach(notes) { note in
                            Circle()
                                .fill(note.color)
                                .frame(width: noteSize, height: noteSize)
                                .offset(y: noteOffset(note.pitch))
                        }
                    }
                }
            }
        }
        .frame(width: 650)
        .padding(.vertical, 28)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.2), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private func noteOffset(_ pitch: CGFloat) -> CGFloat {
        CGFloat(pitch) * (lineSpacing / 2)
    }
}

#Preview {
    MusicSheetView(notes: [
        SheetNote(pitch: 6.5, color: .red),      // C
        SheetNote(pitch: 5.4, color: .orange),   // D
        SheetNote(pitch: 4.3, color: .yellow),   // E
        SheetNote(pitch: 3.2, color: .green),    // F
        SheetNote(pitch: 2.1, color: .teal),     // G
        SheetNote(pitch: 1.0, color: .blue),     // A
        SheetNote(pitch: 0.1, color: .indigo),   // B
        SheetNote(pitch: -1.0, color: .purple)    // C
    ])
}
