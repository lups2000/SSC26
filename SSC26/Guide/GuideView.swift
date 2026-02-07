import SwiftUI

struct GuideView: View {
    @State private var settings = AppSettings.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header Section
                    headerSection
                    
                    // Quick Start Cards
                    VStack(spacing: 20) {
                        Text("Getting Started")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        instructionCard(
                            icon: "hand.tap.fill",
                            iconColor: .blue,
                            title: "1. Choose Your Mode",
                            description: "You can play XyloFingers in two ways:",
                            steps: [
                                "👆 Touch Mode: Tap the xylophone bars directly",
                                "✋ Hand Tracking: Use hand gestures in the air"
                            ]
                        )
                        
                        instructionCard(
                            icon: "music.note.list",
                            iconColor: .purple,
                            title: "2. Explore the App",
                            description: "Three ways to learn and play:",
                            steps: [
                                "📖 Guide: Learn how to use the app (you are here!)",
                                "🎵 Practice: Follow guided songs step-by-step",
                                "🎹 Play XyloFingers: Free play with any mode"
                            ]
                        )
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Hand Tracking Section
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            Image(systemName: "hand.raised.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            
                            Text("Hand Tracking Guide")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Interactive toggle control
                        handTrackingToggleControl
                        
                        handTrackingSteps
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Tips Section
                    VStack(spacing: 20) {
                        Text("Pro Tips")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        tipCard(icon: "lightbulb.fill", color: .yellow, tip: "Start with Level 1 songs in Practice mode to build confidence")
                        tipCard(icon: "speaker.wave.3.fill", color: .orange, tip: "Make sure your device volume is up to hear the beautiful xylophone sounds")
                        tipCard(icon: "figure.play", color: .green, tip: "In hand tracking mode, keep your hand steady and make clear pinch gestures")
                        tipCard(icon: "star.fill", color: .pink, tip: "Practice makes perfect! Play songs multiple times to master them")
                    }
                }
                .padding(24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Guide")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icon and title
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome to XyloFingers!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your magical music journey starts here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("XyloFingers is an interactive xylophone app that lets you make music with your fingers! Whether you tap the screen or use hand gestures, you'll create beautiful melodies in no time.")
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? 
                    Color(white: 0.15).opacity(0.8) : 
                    Color.white.opacity(0.9)
                )
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ?
                        Color.white.opacity(0.1) :
                        Color.white.opacity(0.3),
                    lineWidth: 1
                )
        }
    }
    
    // MARK: - Hand Tracking Steps
    
    private var handTrackingSteps: some View {
        VStack(spacing: 16) {
            handTrackingStep(
                number: 1,
                icon: "ipad.and.iphone",
                title: "Position Your Device",
                description: "Place your iPad on a stand or flat surface with the camera facing you. Make sure you have good lighting."
            )
            
            handTrackingStep(
                number: 2,
                icon: "hand.raised.fingers.spread.fill",
                title: "Show Your Hand",
                description: "Hold your hand in front of the camera (about 30-50cm away). The app will detect your thumb and index finger automatically."
            )
            
            handTrackingStep(
                number: 3,
                icon: "hand.pinch.fill",
                title: "Make a Pinch Gesture",
                description: "Bring your thumb and index finger together to play a note. Position your pinch over the xylophone bar you want to play."
            )
            
            handTrackingStep(
                number: 4,
                icon: "checkmark.circle.fill",
                title: "Watch the Indicators",
                description: "When hand tracking is active, you'll see colored dots on your fingertips (yellow for thumb, red for index) and a green 'Active' status."
            )
        }
    }
    
    private func handTrackingStep(number: Int, icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Step number badge
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Text("\(number)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.blue)
                    
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark ? 
                    Color(white: 0.12).opacity(0.6) : 
                    Color.white.opacity(0.7)
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ?
                        Color.white.opacity(0.08) :
                        Color.white.opacity(0.2),
                    lineWidth: 1
                )
        }
    }
    
    // MARK: - Toggle Reminder Card
    
    private var handTrackingToggleControl: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                settings.isHandTrackingEnabled.toggle()
            }
        }) {
            HStack(spacing: 16) {
                // Icon side
                ZStack {
                    Circle()
                        .fill(
                            settings.isHandTrackingEnabled ?
                                LinearGradient(colors: [.green.opacity(0.3), .green.opacity(0.2)], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: settings.isHandTrackingEnabled ? "hand.raised.fill" : "hand.raised.slash.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(settings.isHandTrackingEnabled ? .green : .gray)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text(settings.isHandTrackingEnabled ? "Hand Tracking Enabled" : "Hand Tracking Disabled")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                    
                    Text(settings.isHandTrackingEnabled ? 
                        "Tap to switch to Touch Mode" : 
                        "Tap to enable Hand Tracking"
                    )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Toggle indicator
                ZStack {
                    Capsule()
                        .fill(settings.isHandTrackingEnabled ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                        .frame(width: 56, height: 32)
                    
                    Capsule()
                        .fill(settings.isHandTrackingEnabled ? Color.green : Color.gray)
                        .frame(width: 26, height: 26)
                        .offset(x: settings.isHandTrackingEnabled ? 12 : -12)
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        settings.isHandTrackingEnabled ?
                            (colorScheme == .dark ? Color.green.opacity(0.15) : Color.green.opacity(0.08)) :
                            (colorScheme == .dark ? Color(white: 0.15).opacity(0.7) : Color.white.opacity(0.8))
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        settings.isHandTrackingEnabled ?
                            Color.green.opacity(0.4) :
                            (colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.2)),
                        lineWidth: 2
                    )
            }
        }
        .buttonStyle(.plain)
    }
    
    private var toggleReminderCard: some View {
        HStack(spacing: 12) {
            Image(systemName: settings.isHandTrackingEnabled ? "checkmark.circle.fill" : "info.circle.fill")
                .font(.system(size: 28))
                .foregroundStyle(settings.isHandTrackingEnabled ? .green : .orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(settings.isHandTrackingEnabled ? "Hand Tracking is ON" : "Hand Tracking is OFF")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(settings.isHandTrackingEnabled ? 
                    "You can now use hand gestures to play!" : 
                    "Currently in Touch Mode. Tap the toggle button to enable hand tracking."
                )
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    settings.isHandTrackingEnabled ?
                        Color.green.opacity(colorScheme == .dark ? 0.2 : 0.1) :
                        Color.orange.opacity(colorScheme == .dark ? 0.2 : 0.1)
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    settings.isHandTrackingEnabled ?
                        Color.green.opacity(0.3) :
                        Color.orange.opacity(0.3),
                    lineWidth: 1.5
                )
        }
    }
    
    // MARK: - Helper Functions
    
    private func instructionCard(icon: String, iconColor: Color, title: String, description: String, steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(steps, id: \.self) { step in
                    Text(step)
                        .font(.subheadline)
                        .padding(.leading, 8)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark ? 
                    Color(white: 0.15).opacity(0.7) : 
                    Color.white.opacity(0.8)
                )
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ?
                        Color.white.opacity(0.1) :
                        Color.white.opacity(0.2),
                    lineWidth: 1
                )
        }
    }
    
    private func tipCard(icon: String, color: Color, tip: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 32)
            
            Text(tip)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .dark ? 
                    Color(white: 0.12).opacity(0.5) : 
                    Color.white.opacity(0.6)
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ?
                        Color.white.opacity(0.08) :
                        Color.white.opacity(0.15),
                    lineWidth: 1
                )
        }
    }
}

#Preview {
    NavigationStack {
        GuideView()
    }
}
