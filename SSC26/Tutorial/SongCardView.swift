import SwiftUI

struct SongCardView: View {
    let song: GuidedSong
    let onSelect: () -> Void
    var height: CGFloat? = nil

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 18) {

                // Header: icon + title + chevron
                HStack(alignment: .center, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color.accentColor.opacity(0.25), Color.accentColor.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 36, height: 36)
                        Image(systemName: "music.note")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .opacity(0.9)
                    }

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

                // Notes preview row
                HStack(spacing: 10) {
                    ForEach(song.colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 18, height: 18)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.08), lineWidth: 0.5)
                            )
                            .shadow(color: color.opacity(0.15), radius: 2, x: 0, y: 1)
                    }

                    Spacer()

                    // Difficulty label
                    HStack(spacing: 6) {
                        HStack(spacing: 3) {
                            ForEach(0..<3) { index in
                                Image(systemName: index < song.difficulty ? "star.fill" : "star")
                                    .foregroundStyle(index < song.difficulty ? .yellow : .secondary)
                                    .font(.system(size: 12, weight: .semibold))
                                    .accessibilityHidden(true)
                            }
                        }

                        Text(song.difficulty == 1 ? "Beginner" : (song.difficulty == 2 ? "Intermediate" : "Advanced"))
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
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(colors: [
                            Color(uiColor: .systemBackground).opacity(0.95),
                            Color(uiColor: .secondarySystemBackground).opacity(0.95)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Song: \(song.title). Difficulty: \(song.difficulty) out of 3.")
        }
        .buttonStyle(.plain)
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
                colors: [.red, .yellow, .teal],
                difficulty: 1
            ), onSelect: {
                print("Selected: First Melody")
            })

            SongCardView(song: GuidedSong(
                title: "Chords in the Rain",
                notes: ["A", "C#", "E"],
                colors: [.mint, .cyan, .blue],
                difficulty: 3
            ), onSelect: {
                print("Selected: Chords in the Rain")
            })
        }
        .padding()
    }
}
