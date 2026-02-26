import Foundation
import UIKit
import AVFoundation
import Vision
import SwiftUI

// MARK: - SwiftUI Wrapper

/// SwiftUI wrapper that embeds the camera view controller into SwiftUI views.
/// Handles hand tracking and provides converted finger tip positions to the parent view.
struct CameraView: UIViewControllerRepresentable {
    /// Callback that receives an array of finger tip positions in the view's coordinate system.
    var pointsProcessorHandler: (([CGPoint]) -> Void)?

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.pointsProcessorHandler = pointsProcessorHandler
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Update the handler when SwiftUI state changes
        uiViewController.pointsProcessorHandler = pointsProcessorHandler
    }
}

// MARK: - Hand Tracking Configuration

/// Minimum confidence threshold for detected hand points (0.0 - 1.0).
/// Points below this confidence level will be filtered out.
var trackingConfidence: Float = 0.3

// MARK: - Camera View Controller

/// Manages the camera feed, hand pose detection, and coordinates conversion.
/// Uses the front-facing camera to track thumb and index finger positions.
final class CameraViewController: UIViewController {
    // MARK: - Properties
    
    /// The AVCapture session that manages camera input and video output.
    private var cameraFeedSession: AVCaptureSession?
    
    /// Layer that displays the live camera preview.
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    /// Serial dispatch queue for processing video frames.
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    /// Vision request for detecting hand poses in camera frames.
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    /// Tracks if a Vision request is currently being processed (prevents queue buildup)
    private var isProcessingFrame = false
    
    /// Callback that receives converted finger tip positions for the SwiftUI parent view.
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the camera preview layer to the view hierarchy
        view.layer.addSublayer(previewLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update preview layer to match view bounds
        previewLayer.frame = view.bounds
        // Adjust rotation based on device orientation
        if let connection = previewLayer.connection {
            updateVideoRotationAngle(on: connection)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Perform all camera setup on a LOW priority background queue
        // This ensures UI responsiveness is prioritized
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // Set up camera session on first appearance (synchronous but on background thread)
                if self.cameraFeedSession == nil {
                    try self.setupAVSession()
                    
                    // Update UI elements on main thread
                    DispatchQueue.main.async {
                        self.previewLayer.session = self.cameraFeedSession
                        self.previewLayer.videoGravity = .resizeAspectFill
                        if let connection = self.previewLayer.connection {
                            self.updateVideoRotationAngle(on: connection)
                        }
                    }
                }
                
                // Start camera feed (already on background thread)
                self.cameraFeedSession?.startRunning()
            } catch {
                print("Camera setup error: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop camera when view disappears to save battery
        cameraFeedSession?.stopRunning()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Camera Setup
    
    /// Updates the video rotation angle on the given connection based on the
    /// current device / interface orientation. Replaces the deprecated
    /// `videoOrientation` property with `videoRotationAngle` (iOS 17+).
    private func updateVideoRotationAngle(on connection: AVCaptureConnection) {
        let orientation = UIDevice.current.orientation

        // Map device orientations that are reliable (not flat / unknown).
        switch orientation {
        case .portrait:
            connection.videoRotationAngle = 90
        case .landscapeLeft:
            connection.videoRotationAngle = 180
        case .landscapeRight:
            connection.videoRotationAngle = 0
        case .portraitUpsideDown:
            connection.videoRotationAngle = 270
        default:
            // Device orientation is unreliable (e.g. flat on a table).
            // Fall back to the interface orientation from the window scene.
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                print("No Valid Interface Present")
                return
            }
            switch windowScene.interfaceOrientation {
            case .portrait:
                connection.videoRotationAngle = 90
            case .portraitUpsideDown:
                connection.videoRotationAngle = 270
            case .landscapeRight:
                connection.videoRotationAngle = 180
            case .landscapeLeft:
                connection.videoRotationAngle = 0
            case .unknown:
                print("No Valid Interface Present")
            @unknown default:
                print("No Valid Interface Present")
            }
        }
    }
    
    /// Configures the AVCapture session with front camera input and video data output.
    func setupAVSession() throws {
        // Get the front-facing camera
        guard let videoDevice = AVCaptureDevice.default( .builtInWideAngleCamera, for: .video, position: .front) else {
            print("Error finding front facing camera.")
            return
        }
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Error creating session")
            return
        }
        
        // Create and configure the capture session
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        guard session.canAddInput(deviceInput) else {
            print("Error adding video to feed.")
            return
        }
        session.addInput(deviceInput)

        // Add video output and set this controller as the delegate
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Error getting video output")
        }
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    // MARK: - Hand Tracking
    
    /// Converts detected finger tip positions from camera space to view coordinates
    /// and passes them to the handler closure.
    func processPoints(_ fingerTips: [CGPoint]) {
        let convertedPoints = fingerTips.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        pointsProcessorHandler?(convertedPoints)
    }
}
    
// MARK: - Video Frame Processing

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    /// Called for each video frame captured by the camera.
    /// Performs hand pose detection and extracts thumb and index finger positions.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Skip frame if still processing previous one (prevents queue buildup)
        guard !isProcessingFrame else { return }
        isProcessingFrame = true
        
        // Create Vision request handler from the camera frame
        let handHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        do {
            // Perform hand pose detection
            try handHandler.perform([handPoseRequest])
            guard let results = handPoseRequest.results?.prefix(1), !results.isEmpty else {
                // No hand detected - update on main thread asynchronously
                DispatchQueue.main.async { [weak self] in
                    self?.processPoints([])
                    self?.isProcessingFrame = false
                }
                return
            }
            
            // Extract thumb and index finger tip positions
            var recognizedPoints: [VNRecognizedPoint] = []
            try results.forEach { point in
                let fingers = try point.recognizedPoints(.all)
                recognizedPoints.append(fingers[.thumbTip]!)
                recognizedPoints.append(fingers[.indexTip]!)
            }
            
            // Filter by confidence and convert to CGPoint with flipped Y coordinate
            let fingerTips = recognizedPoints.filter {
                $0.confidence > trackingConfidence
            }
            .map {
                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
            
            // Update UI on main thread asynchronously (non-blocking)
            DispatchQueue.main.async { [weak self] in
                self?.processPoints(fingerTips)
                self?.isProcessingFrame = false
            }
        } catch {
            print("Error tracking hand: \(error.localizedDescription)")
            isProcessingFrame = false
            cameraFeedSession?.stopRunning()
        }
    }
}
