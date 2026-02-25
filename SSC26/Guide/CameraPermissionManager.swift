import AVFoundation
import UIKit

/// Manages camera permission requests and status checks
@MainActor
final class CameraPermissionManager {
    static let shared = CameraPermissionManager()
    
    private init() {}
    
    /// Check current camera authorization status
    var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    /// Check if camera access is authorized
    var isAuthorized: Bool {
        authorizationStatus == .authorized
    }
    
    /// Request camera permission from the user
    /// - Returns: Bool indicating if permission was granted
    func requestPermission() async -> Bool {
        // Check current status first
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // Already authorized
            return true
            
        case .notDetermined:
            // Request permission
            return await AVCaptureDevice.requestAccess(for: .video)
            
        case .denied, .restricted:
            // Permission denied or restricted
            return false
            
        @unknown default:
            return false
        }
    }
    
    /// Show alert to guide user to Settings if permission was denied
    func showSettingsAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "XyloFingers needs camera access for hand tracking. Please enable it in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        rootViewController.present(alert, animated: true)
    }
}
