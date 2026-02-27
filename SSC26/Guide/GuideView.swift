import SwiftUI

struct GuideView: View {
    @State private var settings = AppSettings.shared
    @Environment(\.colorScheme) private var colorScheme
    
    // Mallet/tracking indicator color - darker for better visibility
    private let malletColor = Color(red: 0.70, green: 0.55, blue: 0.35)
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    headerSection
                    quickActionsSection
                    playModesSection
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    handTrackingSection
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    tipsSection
                    
                    // Call to Action Button
                    startPracticingButton
                }
                .padding(24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Guide")
    }
    
    // MARK: - Hand Tracking Section
    
    private var handTrackingSection: some View {
        VStack(spacing: 20) {
            handTrackingSectionHeader
            cameraPermissionNotice
            handTrackingToggleControl
            handTrackingVisualGuide
        }
    }
    
    private var handTrackingSectionHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "hand.raised.fill")
                .font(.title2)
                .foregroundStyle(.green)
            
            Text("Hand Tracking Guide")
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            headerIcon
            headerDescription
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
    
    private var headerIcon: some View {
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
    }
    
    private var headerDescription: some View {
        Text("XyloFingers is a fun, interactive xylophone app that turns your fingers into musical magic! Tap the screen or use hand gestures to play vibrant notes and create beautiful melodies in seconds.")
            .font(.body)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    // MARK: - Hand Tracking Visual Guide
    
    private var handTrackingVisualGuide: some View {
        VStack(spacing: 16) {
            Text("How It Works")
                .font(.headline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Quick Start Steps at the top
            handTrackingStepsContent
            
            // Main visual demonstration area
            VStack(spacing: 20) {
                // Gesture demonstration card
                gestureVisualizationCard
                
                // Key indicators card
                trackingIndicatorsCard
            }
        }
    }
    
    private var gestureVisualizationCard: some View {
        VStack(spacing: 16) {
            gestureCardHeader
            
            // Two images side by side - no bullet points
            HStack(spacing: 16) {
                // Image 1: Hand position
                Image("hand_position")
                     .resizable()
                     .interpolation(.high)
                     .scaledToFit()
                     .frame(maxWidth: .infinity)
                     .frame(height: 500)
                     .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Image 2: Pinch open gesture
                Image("hand_pinch_open")
                     .resizable()
                     .interpolation(.high)
                     .scaledToFit()
                     .frame(maxWidth: .infinity)
                     .frame(height: 500)
                     .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Image 3: Pinch gesture
                Image("hand_pinch")
                     .resizable()
                     .interpolation(.high)
                     .scaledToFit()
                     .frame(maxWidth: .infinity)
                     .frame(height: 500)
                     .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark ? Color(white: 0.12).opacity(0.7) : Color.white.opacity(0.8))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.green.opacity(0.3), lineWidth: 1.5)
        }
    }
    
    private var gestureCardHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "hand.pinch.fill")
                .font(.title2)
                .foregroundStyle(.green)
            
            Text("The Pinch Gesture")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var gestureKeyPoints: some View {
        VStack(alignment: .leading, spacing: 10) {
            bulletPoint(icon: "1.circle.fill", text: "Hold your hand 30-40cm (12-16 inches) from the front camera", color: .green)
            bulletPoint(icon: "2.circle.fill", text: "Position your hand over a xylophone bar", color: .green)
            bulletPoint(icon: "3.circle.fill", text: "Touch thumb and index finger together to play", color: .green)
        }
    }
    
    private var trackingIndicatorsCard: some View {
        VStack(spacing: 16) {
            trackingIndicatorsHeader
            trackingIndicatorsList
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colorScheme == .dark ? Color(white: 0.12).opacity(0.7) : Color.white.opacity(0.8))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.green.opacity(0.3), lineWidth: 1.5)
        }
    }
    
    private var trackingIndicatorsHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "eye.fill")
                .font(.title2)
                .foregroundStyle(.green)
            
            Text("What You'll See")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var trackingIndicatorsList: some View {

        VStack(spacing: 12) {
            indicatorExplanation(
                color: malletColor,
                symbol: "circle.fill",
                symbolOverlay: "T",
                title: "Thumb Indicator",
                description: "Appears on your thumb tip"
            )
            
            indicatorExplanation(
                color: malletColor,
                symbol: "wand.and.sparkles",
                symbolOverlay: nil,
                title: "Mallet",
                description: "Shows on your index finger tip"
            )
            
            indicatorExplanation(
                color: .orange,
                symbol: "video.fill",
                symbolOverlay: nil,
                title: "Orange Status",
                description: "Camera is ready and waiting for your hand"
            )
            
            indicatorExplanation(
                color: .green,
                symbol: "video.fill",
                symbolOverlay: nil,
                title: "Green Status",
                description: "Actively tracking your hand movements"
            )
        }
    }
    
    private func bulletPoint(icon: String, text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(color)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func indicatorExplanation(color: Color, symbol: String, symbolOverlay: String? = nil, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                if let overlay = symbolOverlay {
                    // Show text overlay (like "T" for thumb)
                    Circle()
                        .fill(color)
                        .frame(width: 22, height: 22)
                    
                    Text(overlay)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    // Show SF Symbol
                    Image(systemName: symbol)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(color)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(color.opacity(0.08))
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
    
    private var handTrackingStepsContent: some View {
            VStack(spacing: 12) {
                compactStep(
                    number: 1,
                    icon: "ipad.landscape",
                    title: "Position iPad",
                    description: "Place iPad horizontally on a stable surface in landscape mode"
                )
                
                compactStep(
                    number: 2,
                    icon: "camera.fill",
                    title: "Enable Hand Tracking",
                    description: "Use the toggle above (camera permission required)"
                )
                
                compactStep(
                    number: 3,
                    icon: "hand.raised.fill",
                    title: "Position Your Hand",
                    description: "Place one hand 30-40cm (12-16 inches) from camera, showing only thumb and index finger"
                )
                
                compactStep(
                    number: 4,
                    icon: "hand.pinch.fill",
                    title: "Pinch to Play",
                    description: "Position hand over bars, pinch thumb and index together to make music!"
                )
            }
    }
    
    private func compactStep(number: Int, icon: String, title: String, description: String) -> some View {
        HStack(spacing: 14) {
            // Step number
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Text("\(number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.green)
            }
            
            // Icon and content
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.green)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .dark ?
                      Color(white: 0.15).opacity(0.8) :
                      Color.white.opacity(0.9))
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
                toggleIcon
                toggleText
                Spacer()
                toggleIndicator
            }
            .padding(20)
            .background {
                toggleBackground
            }
            .overlay {
                toggleBorder
            }
        }
        .buttonStyle(.plain)
    }
    
    private var toggleIcon: some View {
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
    }
    
    private var toggleText: some View {
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
    }
    
    private var toggleIndicator: some View {
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
    
    private var toggleBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
                settings.isHandTrackingEnabled ?
                    (colorScheme == .dark ? Color.green.opacity(0.15) : Color.green.opacity(0.08)) :
                    (colorScheme == .dark ? Color(white: 0.15).opacity(0.7) : Color.white.opacity(0.8))
            )
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
    
    private var toggleBorder: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(
                settings.isHandTrackingEnabled ?
                    Color.green.opacity(0.4) :
                    (colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.2)),
                lineWidth: 2
            )
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
                tipRow(icon: "hand.raised.fill", color: .blue, tip: "Keep your hand steady for clearer detection")
                tipRow(icon: "hand.point.up.left.fill", color: .green, tip: "Show only thumb and index finger for better tracking")
                tipRow(icon: "speaker.wave.3.fill", color: .orange, tip: "Adjust volume for the perfect sound")
                tipRow(icon: "arrow.triangle.2.circlepath", color: .purple, tip: "Switch between modes anytime using the toggle")
                tipRow(icon: "star.fill", color: .pink, tip: "Practice makes perfect; the more you play, the better you get!")
            }
        }
    }
    
    // MARK: - Start Practicing Button
    
    private var startPracticingButton: some View {
        NavigationLink(destination: GuidedSongsView()) {
            HStack(spacing: 12) {
                Image(systemName: "music.note.list")
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text("Ready to Practice?")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.purple)
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(colorScheme == .dark ? Color.purple.opacity(0.15) : Color.purple.opacity(0.08))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color.purple.opacity(0.3), lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
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
        .background(colorScheme == .dark ?
                    Color(white: 0.15).opacity(0.8) :
                    Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

}

#Preview {
    NavigationStack {
        GuideView()
    }
}
