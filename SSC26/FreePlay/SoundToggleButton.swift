import SwiftUI

// MARK: - Sound Toggle Button Component

/// A control button for toggling sound on/off with visual feedback
struct SoundToggleButton: View {
    let isEnabled: Bool
    let onToggle: () -> Void
    
    var body: some View {
        ToggleCardButton(
            label: "Sound",
            isEnabled: isEnabled,
            iconEnabled: "speaker.wave.3.fill",
            iconDisabled: "speaker.slash.fill",
            statusColor: isEnabled ? .blue : Color(red: 0.6, green: 0.6, blue: 0.65),
            statusText: isEnabled ? "UNMUTED" : "MUTED",
            onToggle: onToggle
        )
    }
}

// MARK: - Preview

#Preview("Sound Toggle Button") {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
        SoundToggleButton(
            isEnabled: true,
            onToggle: {
                print("Sound toggle tapped")
            }
        )
    }
}
