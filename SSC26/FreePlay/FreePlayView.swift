import SwiftUI

struct FreePlayView: View {
    @Binding var columnVisibility: NavigationSplitViewVisibility
    
    /// Manages all hand tracking state and pinch detection logic
    @State private var handTrackingManager = HandTrackingManager()
    
    /// Delays camera initialization until explicitly requested (prevents UI freeze)
    @State private var shouldInitializeCamera = false

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Camera Feed (behind everything) - LAZY LOADED
                if shouldInitializeCamera {
                    CameraView { points in
                        handTrackingManager.handleCameraUpdate(points)
                    }
                    .task {
                        // Give extra time for camera to initialize without blocking
                        try? await Task.sleep(for: .milliseconds(100))
                    }
                }

                // MARK: - Classroom Wall Background (semi-transparent so the camera bleeds through)
                ClassroomWallBackground()

                // MARK: - Xylophone with tile frame tracking
                XylophoneWithTracking(manager: handTrackingManager) { _ in }
                    .padding(.horizontal, 20)
                
                // MARK: - Hand tracking visual overlays (wand + thumb dot)
                HandTrackingVisualsOnly(manager: handTrackingManager)
                
                // MARK: - Hand tracking control panel (top-right corner)
                VStack {
                    HStack(spacing: 12) {
                        Spacer()
                        
                        // Sound toggle button
                        SoundToggleButton(
                            isEnabled: AppSettings.shared.isSoundEnabled,
                            onToggle: {
                                AppSettings.shared.toggleSound()
                            }
                        )
                        
                        HandTrackingControlPanel(
                            isEnabled: handTrackingManager.settings.isHandTrackingEnabled,
                            isTracking: handTrackingManager.isTracking,
                            onToggle: {
                                // Toggle the setting immediately (feels responsive)
                                await handTrackingManager.settings.toggleHandTracking()
                                
                                if !handTrackingManager.settings.isHandTrackingEnabled {
                                    // Turning OFF - immediate cleanup
                                    shouldInitializeCamera = false
                                    handTrackingManager.resetTracking()
                                } else {
                                    // Turning ON - delayed camera init to prevent freeze
                                    // Do this in a detached task to not block the button
                                    Task.detached { @MainActor in
                                        // Small delay to let UI update first
                                        try? await Task.sleep(for: .milliseconds(100))
                                        shouldInitializeCamera = true
                                    }
                                }
                            }
                        )
                    }
                    .padding(.trailing, 15)
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
                    
        }
        .ignoresSafeArea()
        .navigationTitle("Free Play")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            columnVisibility = .all
            // Clean up camera when leaving
            shouldInitializeCamera = false
        }
        .task {
            columnVisibility = .detailOnly
            
            // If hand tracking is already enabled (from a previous session),
            // initialize camera after view is settled
            if handTrackingManager.settings.isHandTrackingEnabled {
                try? await Task.sleep(for: .milliseconds(500))
                shouldInitializeCamera = true
            }
        }
    }
}

#Preview {
    FreePlayView(columnVisibility: .constant(.all))
}
