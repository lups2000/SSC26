import AVFoundation

final class SoundPlayer {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    private init() {}

    func play(note: String) {
        // Don't play if sound is disabled
        guard AppSettings.shared.isSoundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: note, withExtension: "wav") else {
            print("Sound file not found for note: \(note)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound:", error)
        }
    }
}
