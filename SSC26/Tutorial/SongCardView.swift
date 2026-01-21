import SwiftUI

struct SongCardView: View {
    let song: GuidedSong
    let onSelect: () -> Void
    var height: CGFloat? = nil

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 18) {
                header
                footer
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: height)
            .background(cardBackground)
            .overlay(cardOverlay)
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                {
                    var parts: [String] = ["Song: \(song.title)."]
                    let description = song.description
                    if !description.isEmpty {
                        parts.append("Description: \(description)")
                    }
                    parts.append("Difficulty: \(song.difficulty) out of 3.")
                    return parts.joined(separator: " ")
                }()
            )
        }
        .buttonStyle(.plain)
    }
}

private extension SongCardView {
    var header: some View {
        HStack(alignment: .center, spacing: 12) {
            iconCircle

            VStack(alignment: .leading, spacing: 4) {
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
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }

    var footer: some View {
        HStack(spacing: 10) {
            // No colors preview anymore
            Spacer()
            difficultyView
        }
    }

    var iconCircle: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color.accentColor.opacity(0.25), Color.accentColor.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 36, height: 36)
            Image(systemName: "music.note")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .opacity(0.9)
        }
    }

    var difficultyView: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { index in
                Image(systemName: "music.note")
                    .foregroundStyle(index < song.difficulty ? Color.accentColor : .secondary)
                    .opacity(index < song.difficulty ? 1.0 : 0.35)
                    .font(.system(size: 20, weight: .bold))
                    .accessibilityHidden(true)
            }
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
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(uiColor: .systemBackground).opacity(0.95),
                        Color(uiColor: .secondarySystemBackground).opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    var cardOverlay: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
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

