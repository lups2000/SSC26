import SwiftUI

struct FreePlayView: View {
    @Binding var columnVisibility: NavigationSplitViewVisibility
    
    /// Manages all hand tracking state and pinch detection logic
    @State private var handTrackingManager = HandTrackingManager()

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Camera Feed (behind everything)
                if handTrackingManager.settings.isHandTrackingEnabled {
                    CameraView { points in
                        handTrackingManager.handleCameraUpdate(points)
                    }
                }

                // MARK: - Background gradient (semi-transparent so the camera bleeds through)
                BackgroundGradient()

                // MARK: - Xylophone with tile frame tracking
                XylophoneWithTracking(manager: handTrackingManager) { _ in }
                
                // MARK: - Hand tracking controls (on top of everything)
                HandTrackingControls(manager: handTrackingManager)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .navigationTitle("Play XyloFingers")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            columnVisibility = .detailOnly
        }
        .onDisappear {
            columnVisibility = .all
        }
    }
}

#Preview {
    FreePlayView(columnVisibility: .constant(.all))
}
