import ARKit
import RealityKit
import SwiftUI
import Combine

/// Manages ARKit hand tracking session and publishes finger positions
@MainActor
class HandTrackingManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    /// Position of the right hand index finger tip in screen coordinates
    @Published var rightIndexFingerPosition: CGPoint?
    
    /// Position of the left hand index finger tip in screen coordinates
    @Published var leftIndexFingerPosition: CGPoint?
    
    /// Whether the AR session is currently running
    @Published var isSessionRunning: Bool = false
    
    /// Error message if something goes wrong
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private var arView: ARView?
    private let session = ARSession()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Start the hand tracking session
    func startTracking(with arView: ARView) {
        self.arView = arView
        
        // Check if body tracking is supported
        guard ARBodyTrackingConfiguration.isSupported else {
            errorMessage = "Hand tracking is not supported on this device."
            return
        }
        
        // Configure AR session for body tracking (includes hands)
        let configuration = ARBodyTrackingConfiguration()
        
        // Enable hand tracking if available (iOS 14+)
        if #available(iOS 14.0, *) {
            // Body tracking automatically includes hand tracking
            configuration.frameSemantics = .bodyDetection
        }
        
        // Run the session
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        arView.session = session
        
        isSessionRunning = true
        errorMessage = nil
    }
    
    /// Pause the hand tracking session
    func pauseTracking() {
        session.pause()
        isSessionRunning = false
    }
    
    /// Resume the hand tracking session
    func resumeTracking() {
        guard let configuration = session.configuration else { return }
        session.run(configuration)
        isSessionRunning = true
    }
    
    /// Stop the hand tracking session completely
    func stopTracking() {
        session.pause()
        isSessionRunning = false
        rightIndexFingerPosition = nil
        leftIndexFingerPosition = nil
    }
    
    // MARK: - Private Methods
    
    /// Process hand anchors and extract finger positions
    private func processHandAnchors(_ anchors: [ARAnchor]) {
        guard let arView = arView else { return }
        
        // Find body anchor (contains hand tracking data)
        guard let bodyAnchor = anchors.compactMap({ $0 as? ARBodyAnchor }).first else {
            return
        }
        
        // Get hand skeletons
        let skeleton = bodyAnchor.skeleton
        
        // Process right hand
        if let rightHandIndex = skeleton.modelTransform(for: .rightHandIndex) {
            // Get the index finger tip joint
            let rightHandIndexTip = skeleton.modelTransform(for: .rightHandIndexTip) ?? rightHandIndex
            
            // Convert to world coordinates
            let worldPosition = simd_make_float3(
                bodyAnchor.transform.columns.3.x + rightHandIndexTip.columns.3.x,
                bodyAnchor.transform.columns.3.y + rightHandIndexTip.columns.3.y,
                bodyAnchor.transform.columns.3.z + rightHandIndexTip.columns.3.z
            )
            
            // Project to screen coordinates
            if let screenPosition = projectToScreen(worldPosition: worldPosition, in: arView) {
                rightIndexFingerPosition = screenPosition
            }
        } else {
            rightIndexFingerPosition = nil
        }
        
        // Process left hand
        if let leftHandIndex = skeleton.modelTransform(for: .leftHandIndex) {
            // Get the index finger tip joint
            let leftHandIndexTip = skeleton.modelTransform(for: .leftHandIndexTip) ?? leftHandIndex
            
            // Convert to world coordinates
            let worldPosition = simd_make_float3(
                bodyAnchor.transform.columns.3.x + leftHandIndexTip.columns.3.x,
                bodyAnchor.transform.columns.3.y + leftHandIndexTip.columns.3.y,
                bodyAnchor.transform.columns.3.z + leftHandIndexTip.columns.3.z
            )
            
            // Project to screen coordinates
            if let screenPosition = projectToScreen(worldPosition: worldPosition, in: arView) {
                leftIndexFingerPosition = screenPosition
            }
        } else {
            leftIndexFingerPosition = nil
        }
    }
    
    /// Project 3D world position to 2D screen coordinates
    private func projectToScreen(worldPosition: SIMD3<Float>, in arView: ARView) -> CGPoint? {
        guard let camera = session.currentFrame?.camera else { return nil }
        
        // Convert world position to camera space
        let viewMatrix = camera.viewMatrix(for: .portrait)
        let projectionMatrix = camera.projectionMatrix(for: .portrait, viewportSize: arView.bounds.size, zNear: 0.001, zFar: 1000)
        
        // Apply view and projection matrices
        let viewPosition = viewMatrix * simd_float4(worldPosition.x, worldPosition.y, worldPosition.z, 1.0)
        let clipPosition = projectionMatrix * viewPosition
        
        // Check if position is in front of camera
        guard clipPosition.w > 0 else { return nil }
        
        // Normalize to NDC (Normalized Device Coordinates)
        let ndc = simd_float3(
            clipPosition.x / clipPosition.w,
            clipPosition.y / clipPosition.w,
            clipPosition.z / clipPosition.w
        )
        
        // Convert NDC to screen coordinates
        let screenX = (ndc.x + 1.0) * 0.5 * Float(arView.bounds.width)
        let screenY = (1.0 - ndc.y) * 0.5 * Float(arView.bounds.height)
        
        return CGPoint(x: CGFloat(screenX), y: CGFloat(screenY))
    }
}

// MARK: - ARSessionDelegate

extension HandTrackingManager: ARSessionDelegate {
    
    nonisolated func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        Task { @MainActor in
            processHandAnchors(anchors)
        }
    }
    
    nonisolated func session(_ session: ARSession, didFailWithError error: Error) {
        Task { @MainActor in
            errorMessage = "AR Session failed: \(error.localizedDescription)"
            isSessionRunning = false
        }
    }
    
    nonisolated func sessionWasInterrupted(_ session: ARSession) {
        Task { @MainActor in
            isSessionRunning = false
        }
    }
    
    nonisolated func sessionInterruptionEnded(_ session: ARSession) {
        Task { @MainActor in
            isSessionRunning = true
        }
    }
}
