import SwiftUI

struct NoteView: View {
    let note: SheetNote
    let noteSize: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(note.color)
                .opacity(note.isTarget ? 1 : 0.3)
                .frame(width: noteSize, height: noteSize)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 1, x: 0, y: 1)
        }
    }
}
