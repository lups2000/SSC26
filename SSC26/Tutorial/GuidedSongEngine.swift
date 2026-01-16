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

    init(song: GuidedSong) {
        self.song = song
    }

    var targetNote: String? {
        guard !isCompleted, currentIndex < song.notes.count else { return nil }
        return song.notes[currentIndex]
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
