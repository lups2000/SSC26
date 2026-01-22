import SwiftUI

struct SheetNote: Identifiable {
    let id = UUID()
    let pitch: CGFloat
    let color: Color
    let isTarget: Bool
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 6
    var shakesPerUnit: CGFloat = 5
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * shakesPerUnit),
                y: -0.5 * sin(animatableData * .pi * shakesPerUnit)
            )
        )
    }
}

struct MusicSheetView: View {
    let notes: [SheetNote]
    let title: String?
    let isCorrect: Bool
    let progress: Double?

    let onRestart: (() -> Void)
    let onClose: (() -> Void)

    private let lineSpacing: CGFloat = 25
    private let noteSize: CGFloat = 25

    @State private var animateTarget = false
    @State private var shakeTrigger: CGFloat = 0
    
    private var isSongCompleted: Bool {
        if let progress { return progress >= 1 }
        return false
    }

    var body: some View {
        ZStack {
            ChalkboardBackground()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    if let title, !title.isEmpty {
                        Text(title)
                            .font(.custom("Marker Felt", size: 30).weight(.thin))
                            .foregroundStyle(Color.white)
                            .kerning(0.5)
                            .rotationEffect(.degrees(-2))
                            .shadow(color: .white.opacity(0.12), radius: 1, x: 0, y: 1)
                            .padding(.leading, 6)
                    }

                    Spacer()

                    if let progress, progress >= 0, progress <= 1 {
                        HStack(spacing: 8) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.white.opacity(0.15))
                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(Color.white)
                                        .frame(width: max(0, min(geo.size.width, geo.size.width * progress)))
                                }
                            }
                            .frame(width: 140, height: 15)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.top, -40)

                if isSongCompleted {
                    VStack(spacing: 16) {
                        Text("Congratulations!")
                            .font(.custom("Marker Felt", size: 36).weight(.thin))
                            .foregroundStyle(Color.white)
                            .shadow(color: .white.opacity(0.15), radius: 1.5, x: 0, y: 1)

                        if let title, !title.isEmpty {
                            Text("You successfully completed this song")
                                .font(.custom("Marker Felt", size: 25).weight(.thin))
                                .foregroundStyle(Color.white.opacity(0.9))
                        }

                        HStack(spacing: 16) {
                            Button {
                                onRestart()
                            } label: {
                                Text("Restart")
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white))
                                    .foregroundStyle(Color.black)
                            }

                            Button {
                                onClose()
                            } label: {
                                Text("Close")
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.white, lineWidth: 2))
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    HStack(alignment: .center, spacing: 16) {
                        Text("𝄞")
                            .font(.system(size: 100, weight: .regular))
                            .foregroundStyle(Color.white)
                            .shadow(color: .white.opacity(0.15), radius: 1.5, x: 0, y: 1)
                            .offset(y: -10)

                        ZStack {
                            StaffLinesView(lineSpacing: lineSpacing)

                            HStack(spacing: 80) {
                                ForEach(notes) { note in
                                    ZStack {
                                        NoteView(note: note, noteSize: noteSize)

                                        if note.isTarget {
                                            TargetIndicatorView(color: note.color, shakeTrigger: $shakeTrigger, isCorrect: isCorrect)
                                        }
                                    }
                                    .offset(y: noteOffset(note.pitch))
                                }
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
    ], title: "First Melody", isCorrect: false, progress: 1.42, onRestart: {
        print("Restart")
    }, onClose: {
        print("Close")
    })
}
