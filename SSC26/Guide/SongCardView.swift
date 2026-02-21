import SwiftUI

struct SongCardView: View {
    let song: GuidedSong
    let onSelect: () -> Void
    var height: CGFloat? = nil
    
    @State private var isPressed = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 16) {
                header
                
                Spacer()
                
                footer
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: height ?? 160)
            .background(cardBackground)
            .overlay(cardOverlay)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(isPressed ? 0.1 : 0.08), radius: isPressed ? 6 : 12, x: 0, y: isPressed ? 3 : 6)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                {
                    var parts: [String] = ["Song: \(song.title)."]
                    let description = song.description
                    if !description.isEmpty {
                        parts.append(description)
                    }
                    parts.append("Difficulty: \(difficultyLabel).")
                    parts.append("\(song.notes.count) notes.")
                    return parts.joined(separator: " ")
                }()
            )
            .accessibilityAddTraits(.isButton)
        }
        .buttonStyle(SongCardButtonStyle(isPressed: $isPressed))
    }
}

struct SongCardButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

private extension SongCardView {
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                iconCircle
                Spacer()
                difficultyBadge
            }
            
            Text(song.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            let description = song.description
            if !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
    }

    var footer: some View {
        HStack(spacing: 8) {
            Image(systemName: "music.note")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Text("\(song.notes.count) notes")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.tertiary)
        }
    }

    var iconCircle: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            difficultyColor.opacity(0.2),
                            difficultyColor.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
            
            Image(systemName: "music.note")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(difficultyColor)
        }
    }
    
    var difficultyBadge: some View {
        HStack(spacing: 2) {
            ForEach(0..<song.difficulty, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(difficultyColor)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule()
                .fill(difficultyColor.opacity(0.15))
        }
    }
    
    var difficultyColor: Color {
        switch song.difficulty {
        case 1: return .green
        case 2: return .orange
        case 3: return .red
        default: return .blue
        }
    }

    var difficultyLabel: String {
        switch song.difficulty {
        case 1: return "Beginner"
        case 2: return "Intermediate"
        default: return "Advanced"
        }
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .opacity(colorScheme == .dark ? 0.9 : 0.95)
    }

    var cardOverlay: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .strokeBorder(
                colorScheme == .dark ? 
                    Color.white.opacity(0.15) : 
                    Color.white.opacity(0.3), 
                lineWidth: 1
            )
    }
}

#Preview {
    ZStack {
        BackgroundGradient()
        SongCardView(song: GuidedSong(
            title: "First Melody",
            description: "A simple melody to get you started!",
            notes: ["C", "E", "G"],
            difficulty: 1
        ), onSelect: {
            print("Selected: First Melody")
        })
        .frame(width: 400, height: 300).padding()
    }
}

