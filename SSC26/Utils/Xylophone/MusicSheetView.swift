import SwiftUI

struct SheetNote: Identifiable {
    let id = UUID()
    let pitch: CGFloat
    let color: Color
    let isTarget: Bool
}

struct MusicSheetView: View {
    let notes: [SheetNote]
    let title: String?

    private let lineSpacing: CGFloat = 25
    private let noteSize: CGFloat = 25

    var body: some View {
        ZStack {
            // Chalkboard with wood frame
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.08, green: 0.08, blue: 0.09), Color(red: 0.06, green: 0.06, blue: 0.07)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // Subtle chalk dust texture approximation
                    ZStack {
                        RadialGradient(
                            colors: [Color.white.opacity(0.06), .clear],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 400
                        )
                        RadialGradient(
                            colors: [Color.white.opacity(0.03), .clear],
                            center: .bottomTrailing,
                            startRadius: 0,
                            endRadius: 500
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                )
                .padding(20)
                .background(
                    // Wood frame
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.5, green: 0.32, blue: 0.14), Color(red: 0.38, green: 0.24, blue: 0.11)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.black.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 10)
                )

            // Content drawn in white chalk with optional title above
            VStack(alignment: .leading, spacing: 12) {
                if let title, !title.isEmpty {
                    Text(title)
                        .font(.custom("Marker Felt", size: 30).weight(.thin))
                        .foregroundStyle(Color.white)
                        .kerning(0.5)
                        .rotationEffect(.degrees(-2))
                        .shadow(color: .white.opacity(0.12), radius: 1, x: 0, y: 1)
                        .padding(.leading, 6)
                        .padding(.top, -40)
                }
                HStack(alignment: .center, spacing: 16) {
                    // Treble clef in chalk
                    Text("𝄞")
                        .font(.system(size: 100, weight: .regular))
                        .foregroundStyle(Color.white)
                        .shadow(color: .white.opacity(0.15), radius: 1.5, x: 0, y: 1)
                        .offset(y: -10)

                    ZStack {
                        // Staff lines in chalk
                        VStack(spacing: lineSpacing) {
                            ForEach(0..<5) { _ in
                                Capsule()
                                    .fill(Color.white.opacity(0.9))
                                    .frame(height: 2)
                                    .shadow(color: .white.opacity(0.08), radius: 0.5, x: 0, y: 0.5)
                            }
                        }

                        // Notes as colored circles with chalky white edges
                        HStack(spacing: 80) {
                            ForEach(notes) { note in
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
                                    
                                    // Target indicator
                                    if note.isTarget {
                                        Rectangle()
                                            .fill(note.color)
                                            .opacity(0.3)
                                            .cornerRadius(15)
                                            .frame(width: 50, height: 80)
                                    }
                                }
                                .offset(y: noteOffset(note.pitch))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 35)
        }
        .frame(width: 650, height: 300)
    }

    private func noteOffset(_ pitch: CGFloat) -> CGFloat {
        CGFloat(pitch) * (lineSpacing / 2)
    }
}

#Preview {
    MusicSheetView(notes: [
        SheetNote(pitch: 6.5, color: .red, isTarget: true),   // C
        SheetNote(pitch: 5.4, color: .orange, isTarget: false),   // D
        SheetNote(pitch: 4.3, color: .yellow, isTarget: false),   // E
        SheetNote(pitch: 3.2, color: .green, isTarget: false),    // F
        SheetNote(pitch: 2.1, color: .teal, isTarget: false),     // G
        SheetNote(pitch: 1.0, color: .blue, isTarget: false),     // A
        SheetNote(pitch: 0.1, color: .indigo, isTarget: false),   // B
        SheetNote(pitch: -1.0, color: .purple, isTarget: false)    // C
    ], title: "First Melody")
}
