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
            .accessibilityLabel("Song: \(song.title). Difficulty: \(song.difficulty) out of 3.")
        }
        .buttonStyle(.plain)
    }
}

private extension SongCardView {
    var header: some View {
        HStack(alignment: .center, spacing: 12) {
            iconCircle

            Text(song.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .opacity(0.8)
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
        HStack(spacing: 6) {
            HStack(spacing: 3) {
                ForEach(0..<3) { index in
                    Image(systemName: index < song.difficulty ? "star.fill" : "star")
                        .foregroundStyle(index < song.difficulty ? .yellow : .secondary)
                        .font(.system(size: 12, weight: .semibold))
                        .accessibilityHidden(true)
                }
            }

            Text(difficultyLabel)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.secondary.opacity(0.12))
                )
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
        LinearGradient(colors: [.blue.opacity(0.08), .purple.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        VStack(spacing: 16) {
            SongCardView(song: GuidedSong(
                title: "First Melody",
                notes: ["C", "E", "G"],
                difficulty: 1
            ), onSelect: {
                print("Selected: First Melody")
            })

            SongCardView(song: GuidedSong(
                title: "Chords in the Rain",
                notes: ["A", "C_H", "E"],
                difficulty: 3
            ), onSelect: {
                print("Selected: Chords in the Rain")
            })
        }
        .padding()
    }
}
