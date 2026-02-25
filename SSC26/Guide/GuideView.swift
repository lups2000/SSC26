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
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Play Modes Section
                    playModesSection
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Hand Tracking Section
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            Image(systemName: "hand.raised.fill")
                                .font(.title2)
                                .foregroundStyle(.green)
                            
                            Text("Hand Tracking Guide")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Camera permission notice
                        cameraPermissionNotice
                        
                        // Interactive toggle control
                        handTrackingToggleControl
                        
                        handTrackingSteps
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Tips
                    tipsSection
                }
                .padding(24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Guide")
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Two Ways to Play")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Choose the mode that works best for you")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                playModeCard(
                    icon: "hand.tap.fill",
                    color: .blue,
                    title: "Touch Mode",
                    description: "Tap the xylophone bars directly on screen. Perfect for beginners and quick play sessions.",
                    badge: "Beginner"
                )
                
                playModeCard(
                    icon: "hand.raised.fill",
                    color: .green,
                    title: "Hand Tracking",
                    description: "Use pinch gestures in the air to play notes. A hands-free, magical way to make music.",
                    badge: "Hands-Free"
                )
            }
        }
    }
    
    // MARK: - Play Modes
    
    private var playModesSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What to Play")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Learn with guidance or explore freely")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                playModeCard(
                    icon: "music.note.list",
                    color: .purple,
                    title: "Practice",
                    description: "Follow along with guided songs. Visual cues show you which notes to play next.",
                    badge: "Guided"
                )
                
                playModeCard(
                    icon: "music.quarternote.3",
                    color: .orange,
                    title: "Free Play",
                    description: "Create your own melodies. Explore the xylophone and make music your way.",
                    badge: "Creative"
                )
            }
        }
    }
    
    private func playModeCard(icon: String, color: Color, title: String, description: String, badge: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(color)
                
                Spacer()
                
                Text(badge)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.15))
                    .clipShape(Capsule())
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark ? Color(white: 0.15).opacity(0.7) : Color.white.opacity(0.8))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(color.opacity(0.3), lineWidth: 1.5)
        }
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
            
            Text("XyloFingers is a fun, interactive xylophone app that turns your fingers into musical magic! Tap the screen or use hand gestures to play vibrant notes and create beautiful melodies in seconds.")
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
    
    private var cameraPermissionNotice: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Camera Access")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("You'll be asked for camera permission when you enable hand tracking")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(colorScheme == .dark ? Color.blue.opacity(0.12) : Color.blue.opacity(0.08))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1.5)
        }
    }
    
    private var handTrackingSteps: some View {
        VStack(spacing: 16) {
            handTrackingStep(
                number: 1,
                icon: "ipad.landscape",
                title: "Rotate to Landscape",
                description: "Place your iPad in landscape orientation with the front camera facing you. Ensure good lighting for best results."
            )
            
            handTrackingStep(
                number: 2,
                icon: "camera.fill",
                title: "Enable Hand Tracking",
                description: "Use the toggle control above or in the control panel. You'll be prompted to grant camera access when enabling it for the first time."
            )
            
            handTrackingStep(
                number: 3,
                icon: "hand.raised.fingers.spread.fill",
                title: "Show Your Hand",
                description: "Hold your hand 30-50cm from the camera. You'll see a small purple dot on your thumb and a magic wand indicator on your index finger."
            )
            
            handTrackingStep(
                number: 4,
                icon: "hand.pinch.fill",
                title: "Pinch to Play",
                description: "Touch your thumb and index finger together above a xylophone bar. Each pinch plays that note!"
            )
            
            handTrackingStep(
                number: 5,
                icon: "video.fill",
                title: "Watch the Status Indicator",
                description: "Look for the status indicator: orange means ready and waiting, green means actively tracking your hand. If tracking is lost, adjust your hand position or lighting."
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
                            colors: [.green, .green.opacity(0.8)],
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
                        .foregroundStyle(.green)
                    
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
    

    
    // MARK: - Tips
    
    private var tipsSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Tips")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Get the most out of your experience")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 10) {
                tipRow(icon: "sun.max.fill", color: .yellow, tip: "Good lighting improves hand tracking accuracy")
                tipRow(icon: "hand.point.up.left.fill", color: .blue, tip: "Keep your hand steady for clearer detection")
                tipRow(icon: "speaker.wave.3.fill", color: .orange, tip: "Adjust volume in Settings for the perfect sound")
                tipRow(icon: "arrow.triangle.2.circlepath", color: .green, tip: "Switch between modes anytime using the toggle")
                tipRow(icon: "star.fill", color: .pink, tip: "Experiment with different gestures and speeds!")
            }
        }
    }
    
    private func tipRow(icon: String, color: Color, tip: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 32)
            
            Text(tip)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(12)
        .background(colorScheme == .dark ? Color(white: 0.12).opacity(0.5) : Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

}

#Preview {
    NavigationStack {
        GuideView()
    }
}
