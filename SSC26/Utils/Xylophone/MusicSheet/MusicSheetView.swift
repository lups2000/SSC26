import SwiftUI

struct SheetNote: Identifiable {
    let id = UUID()
    let pitch: CGFloat
    let color: Color
    let isTarget: Bool
}

struct BackgroundMusicIcon: Identifiable {
    let id = UUID()
    let symbol: String
    let xOffset: CGFloat
    let yOffset: CGFloat
    let size: CGFloat
    let rotation: Double
    let opacity: Double
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

private struct EngravedNoteView: View {
    let note: SheetNote
    let noteSize: CGFloat
    let stemLength: CGFloat = 35

    private var stemUp: Bool { note.pitch >= 0 }

    var body: some View {
        ZStack {
            // Ledger line (simple: show one if far from staff)
            if abs(note.pitch) > 6.5 { // tune threshold to mapping
                Rectangle()
                    .fill(Color.white)
                    .frame(width: noteSize * 1.6, height: 1.5)
            }

            // Notehead
            Ellipse()
                .fill(Color.white)
                .frame(width: noteSize * 0.9, height: noteSize * 0.8)
                .rotationEffect(.degrees(-20))
                .overlay(
                    Ellipse()
                        .stroke(Color.black.opacity(0.15), lineWidth: 0.0)
                )
                .shadow(color: .black.opacity(0.12), radius: 1, x: 0, y: 1)
                .overlay(
                    Ellipse()
                        .stroke(Color.white.opacity(0.9), lineWidth: 1)
                        .rotationEffect(.degrees(-20))
                )

            // Stem (white to match ink on chalkboard; tweak if needed)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color.white)
                .frame(width: 2.5, height: stemLength)
                .offset(x: stemUp ? noteSize * 0.40 : -noteSize * 0.55,
                        y: stemUp ? -stemLength/2 : stemLength/2)
        }
    }
}

struct MusicSheetView: View {
    let notes: [SheetNote]
    let title: String?
    let isCorrect: Bool
    let progress: Double?

    let onRestart: (() -> Void)
    let onClose: (() -> Void)

    private let lineSpacing: CGFloat = 22
    private let noteSize: CGFloat = 25

    @State private var animateTarget = false
    @State private var shakeTrigger: CGFloat = 0
    
    private var isSongCompleted: Bool {
        if let progress { return progress >= 1 }
        return false
    }
    
    private let backgroundIcons: [BackgroundMusicIcon] = [
        .init(symbol: "music.note", xOffset: -200, yOffset: -40, size: 40, rotation: -15, opacity: 0.6),
        .init(symbol: "music.note", xOffset: 200, yOffset: -40, size: 40, rotation: -15, opacity: 0.6),
        .init(symbol: "music.note", xOffset: -250, yOffset: 40, size: 40, rotation: -5, opacity: 0.6),
        .init(symbol: "music.note", xOffset: 250, yOffset: 40, size: 40, rotation: -10, opacity: 0.6),
        .init(symbol: "music.note", xOffset: -160, yOffset: 60, size: 40, rotation: -15, opacity: 0.6),
        .init(symbol: "music.note", xOffset: 160, yOffset: 60, size: 40, rotation: -10, opacity: 0.6),
        // Add more icons here as needed
    ]

    var body: some View {
        ZStack {
            // MARK: - Wall mounting shadow (behind the board)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.black.opacity(0.2))
                .blur(radius: 12)
                .offset(x: 4, y: 8)
            
            // MARK: - Chalkboard with frame
            ZStack {
                // Chalkboard surface
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.15, green: 0.18, blue: 0.15),
                                Color(red: 0.12, green: 0.15, blue: 0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Subtle chalk dust texture
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.02))
                    .blendMode(.overlay)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
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

                    if let progress, progress >= 0, progress < 1 {
                            ZStack(alignment: .leading) {
                                // Background track
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)

                                // Progress fill
                                GeometryReader { geo in
                                    let w = max(0, min(geo.size.width, geo.size.width * progress))
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.95), Color.white.opacity(0.8)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: w)
                                        .shadow(color: .white.opacity(0.4), radius: 3, x: 0, y: 0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: progress)
                                }
                                .padding(2)
                            }
                            .frame(width: 140, height: 18)
                    }
                }
                .padding(.top, -40)

                if isSongCompleted {
                    ZStack {
                        // Background icons with manual positions
                        ForEach(backgroundIcons) { icon in
                            Image(systemName: icon.symbol)
                                .font(.system(size: icon.size))
                                .foregroundColor(Color.white.opacity(icon.opacity))
                                .rotationEffect(.degrees(icon.rotation))
                                .offset(x: icon.xOffset, y: icon.yOffset)
                        }

                        VStack(spacing: 16) {
                            Text("Congratulations!")
                                .font(.custom("Marker Felt", size: 36).weight(.thin))
                                .foregroundStyle(Color.white)
                                .shadow(color: .white.opacity(0.15), radius: 1.5, x: 0, y: 1)
                                .kerning(0.5)
                                .rotationEffect(.degrees(0.8))

                            HStack(spacing: 16) {
                                // Restart button (hand-drawn style)
                                Button {
                                    onRestart()
                                } label: {
                                    Text("Restart")
                                        .font(.custom("Marker Felt", size: 24).weight(.thin))
                                        .foregroundStyle(Color.white)
                                        .kerning(0.5)
                                        .shadow(color: .white.opacity(0.12), radius: 1, x: 0, y: 1)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(
                                            // Hand-drawn circle/bubble
                                            ZStack {
                                                // Chalk outline (slightly irregular)
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke(Color.white.opacity(0.7), lineWidth: 3)
                                                
                                                // Inner subtle fill
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .fill(Color.white.opacity(0.08))
                                            }
                                        )
                                }
                                .buttonStyle(.plain)

                                // Close button (hand-drawn style)
                                Button {
                                    onClose()
                                } label: {
                                    Text("Close")
                                        .font(.custom("Marker Felt", size: 24).weight(.thin))
                                        .foregroundStyle(Color.white)
                                        .kerning(0.5)
                                        .shadow(color: .white.opacity(0.12), radius: 1, x: 0, y: 1)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(
                                            // Hand-drawn circle/bubble
                                            ZStack {
                                                // Chalk outline (slightly irregular)
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke(Color.white.opacity(0.7), lineWidth: 3)
                                                
                                                // Inner subtle fill
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .fill(Color.white.opacity(0.08))
                                            }
                                        )
                                }
                                .buttonStyle(.plain)
                            }.padding(.top, 15)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                else {
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
                                        EngravedNoteView(note: note, noteSize: noteSize)

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
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            }
            .overlay {
                // MARK: - Wooden frame
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.3, blue: 0.2),
                                Color(red: 0.35, green: 0.25, blue: 0.15)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 16
                    )
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            
            // MARK: - Chalk tray at bottom
            ChalkTrayView()
                .offset(y: 145)
        }
        .frame(width: 650, height: 280)
    }

    private func noteOffset(_ pitch: CGFloat) -> CGFloat {
        CGFloat(pitch) * (lineSpacing / 2)
    }
}


// MARK: - Mounting Screw

private struct MountingScrewView: View {
    var body: some View {
        ZStack {
            // Screw head shadow
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: 14, height: 14)
                .blur(radius: 2)
                .offset(x: 1, y: 1)
            
            // Screw head
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.7, green: 0.7, blue: 0.72),
                            Color(red: 0.5, green: 0.5, blue: 0.52)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 12, height: 12)
            
            // Phillips head slot
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 6, height: 1.5)
                
                Rectangle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 1.5, height: 6)
            }
        }
    }
}

// MARK: - Chalk Tray

private struct ChalkTrayView: View {
    var body: some View {
        ZStack {
            // Shadow
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.black.opacity(0.25))
                .frame(width: 580, height: 24)
                .blur(radius: 4)
                .offset(y: 4)
            
            // Tray body
            ZStack {
                // Main tray
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.45, green: 0.35, blue: 0.25),
                                Color(red: 0.38, green: 0.28, blue: 0.18)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 580, height: 20)
                
                // Lip/edge highlight
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color(red: 0.5, green: 0.4, blue: 0.3))
                    .frame(width: 580, height: 3)
                    .offset(y: -8.5)
                
                // Chalk pieces in the tray
                HStack(spacing: 20) {
                    ChalkPieceView(color: .white, length: 30)
                    ChalkPieceView(color: .yellow, length: 25)
                    ChalkPieceView(color: .pink, length: 35)
                    ChalkPieceView(color: .cyan, length: 28)
                }
                .offset(x: -180, y: -2)
                
                // Eraser
                EraserView()
                    .offset(x: 230, y: -6)
            }
        }
    }
}

// MARK: - Chalk Piece

private struct ChalkPieceView: View {
    let color: Color
    let length: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        color,
                        color.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: length, height: 8)
            .rotationEffect(.degrees(-3))
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
    }
}

// MARK: - Eraser

private struct EraserView: View {
    var body: some View {
        ZStack {
            // Eraser body
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.85, blue: 0.70),
                            Color(red: 0.88, green: 0.78, blue: 0.63)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 55, height: 20)
            
            // Felt pad (bottom) - darker brown
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color(red: 0.45, green: 0.35, blue: 0.25))
                .frame(width: 55, height: 6)
                .offset(y: 7)
            
            // Chalk residue on felt
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color.white.opacity(0.6))
                .frame(width: 55, height: 6)
                .offset(y: 7)
                .blendMode(.overlay)
        }
        .rotationEffect(.degrees(1))
        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
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
    ], title: "First Melody", isCorrect: false, progress: 1.42, onRestart: {
        print("Restart")
    }, onClose: {
        print("Close")
    })
}
