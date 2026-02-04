import ARKit
import UIKit

/// Helper class to check device capabilities for hand tracking
struct DeviceCapabilities {
    
    /// Check if the device supports ARKit body tracking (required for hand tracking)
    static var supportsHandTracking: Bool {
        // Hand tracking requires ARBodyTrackingConfiguration
        return ARBodyTrackingConfiguration.isSupported
    }
    
    /// Check if camera access is authorized
    static var isCameraAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    /// Request camera permission
    static func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /// Get a user-friendly message about device compatibility
    static var compatibilityMessage: String? {
        if !supportsHandTracking {
            return "Hand tracking requires an iPhone XS/XR or newer, or an iPad Pro (2018) or newer."
        }
        return nil
    }
}
