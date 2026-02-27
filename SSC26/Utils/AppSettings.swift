import SwiftUI

@MainActor
@Observable
final class AppSettings {
    static let shared = AppSettings()
    
    var isHandTrackingEnabled: Bool = false
    var isSoundEnabled: Bool = true
    
    private init() {}
    
    /// Enable hand tracking with camera permission check
    /// - Returns: Bool indicating if hand tracking was successfully enabled
    @discardableResult
    func enableHandTracking() async -> Bool {
        // Request camera permission
        let granted = await CameraPermissionManager.shared.requestPermission()
        
        if granted {
            isHandTrackingEnabled = true
            return true
        } else {
            // Permission denied - show alert to guide user to Settings
            CameraPermissionManager.shared.showSettingsAlert()
            isHandTrackingEnabled = false
            return false
        }
    }
    
    /// Disable hand tracking
    func disableHandTracking() {
        isHandTrackingEnabled = false
    }
    
    /// Toggle hand tracking on/off with permission handling
    func toggleHandTracking() async {
        if isHandTrackingEnabled {
            // Currently enabled - just disable it
            disableHandTracking()
        } else {
            // Currently disabled - enable with permission check
            await enableHandTracking()
        }
    }
    
    /// Toggle sound on/off
    func toggleSound() {
        isSoundEnabled.toggle()
    }
}
