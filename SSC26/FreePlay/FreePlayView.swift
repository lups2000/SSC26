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
                if handTrackingManager.settings.isHandTrackingEnabled && shouldInitializeCamera {
                    CameraView { points in
                        handTrackingManager.handleCameraUpdate(points)
                    }
                }

                // MARK: - Background gradient (semi-transparent so the camera bleeds through)
                BackgroundGradient()

                // MARK: - Xylophone with tile frame tracking
                XylophoneWithTracking(manager: handTrackingManager) { _ in }.padding(.horizontal, 20)
                
                // MARK: - Hand tracking visual overlays (wand + thumb dot)
                HandTrackingVisualsOnly(manager: handTrackingManager)
                
                // MARK: - Hand tracking control panel (top-right corner)
                VStack {
                    HStack {
                        Spacer()
                        
                        HandTrackingControlPanel(
                            isEnabled: handTrackingManager.settings.isHandTrackingEnabled,
                            isTracking: handTrackingManager.isTracking,
                            onToggle: {
                                await handTrackingManager.settings.toggleHandTracking()
                                if !handTrackingManager.settings.isHandTrackingEnabled {
                                    handTrackingManager.resetTracking()
                                    shouldInitializeCamera = false
                                } else {
                                    // Delay camera initialization to prevent UI freeze
                                    try? await Task.sleep(for: .milliseconds(300))
                                    shouldInitializeCamera = true
                                }
                            }
                        )
                    }
                    .padding(.trailing, 15)
                    .padding(.top, 30)
                    
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
        }
        .task {
            columnVisibility = .detailOnly
            
            // Delay camera initialization to allow view to render first
            // This dramatically improves perceived performance
            try? await Task.sleep(for: .milliseconds(1000))
            if handTrackingManager.settings.isHandTrackingEnabled {
                shouldInitializeCamera = true
            }
        }
    }
}

#Preview {
    FreePlayView(columnVisibility: .constant(.all))
}
