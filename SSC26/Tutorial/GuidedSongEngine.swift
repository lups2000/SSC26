import Foundation
import SwiftUI
import Combine

@MainActor
@Observable
final class GuidedSongEngine: Observable {
    private(set) var song: GuidedSong
    private(set) var currentIndex: Int = 0
    private(set) var isCompleted: Bool = false
    private(set) var lastInputWasCorrect: Bool? = nil

    // Windowing configuration: how many notes to show ahead of the current target
    var windowSize: Int

    init(song: GuidedSong, windowSize: Int = 5) {
        self.song = song
        self.windowSize = max(1, windowSize)
    }

    var targetNote: String? {
        guard !isCompleted, currentIndex < song.notes.count else { return nil }
        return song.notes[currentIndex]
    }

    /// A fixed-size window of upcoming notes starting at the current index.
    /// Always returns exactly `windowSize` items. If the song has fewer remaining notes,
    /// pads the tail with empty placeholders.
    var visibleWindow: [(note: String, index: Int?)] {
        var result: [(String, Int?)] = []
        result.reserveCapacity(windowSize)

        var i = 0
        while i < windowSize {
            let global = currentIndex + i
            if global < song.notes.count {
                result.append((song.notes[global], global))
            } else {
                // Pad with placeholders once we run out of real notes
                result.append(("", nil))
            }
            i += 1
        }
        return result
    }

    func reset() {
        currentIndex = 0
        isCompleted = false
        lastInputWasCorrect = nil
    }

    // Returns true if the input matches the current target and advances state
    @discardableResult
    func handleInput(note: String) -> Bool {
        guard !isCompleted else { return false }
        guard let target = targetNote else { return false }

        let isCorrect = (note == target)
        lastInputWasCorrect = isCorrect

        if isCorrect {
            currentIndex += 1
            if currentIndex >= song.notes.count {
                isCompleted = true
            }
        }
        return isCorrect
    }
}
