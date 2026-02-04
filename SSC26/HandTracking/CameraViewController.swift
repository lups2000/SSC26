import Foundation
import UIKit
import AVFoundation
import Vision

var trackingConfidence: Float = 0.2

final class CameraViewController: UIViewController {
    private var cameraFeedSession: AVCaptureSession?
    override func loadView() {
        view = CameraPreview()
    }
    private var cameraView: CameraPreview { view as! CameraPreview }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
                if let connection = self.cameraView.previewLayer.connection {
                    updateVideoRotationAngle(on: connection)
                }
            }
            DispatchQueue.global(qos: .userInteractive).async {
                self.cameraFeedSession?.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let connection = self.cameraView.previewLayer.connection {
            updateVideoRotationAngle(on: connection)
        }
    }
    
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
    
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default( .builtInWideAngleCamera, for: .video, position: .front) else {
            print("Error finding front facing camera.")
            return
        }
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Error creating session")
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        guard session.canAddInput(deviceInput) else {
            print("Error adding video to feed.")
            return
        }
        session.addInput(deviceInput)

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
    
    
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
    func processPoints(_ fingerTips: [CGPoint]) {
        let convertedPoints = fingerTips.map {
            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        pointsProcessorHandler?(convertedPoints)
    }
}
    
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var fingerTips: [CGPoint] = []
        defer {
            DispatchQueue.main.sync {
                self.processPoints(fingerTips)
            }
        }
        let handHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        do {
            try handHandler.perform([handPoseRequest])
            guard let results = handPoseRequest.results?.prefix(1), !results.isEmpty  else {
                return
            }
            var recognizedPoints: [VNRecognizedPoint] = []
            try results.forEach { point in
                let fingers = try point.recognizedPoints(.all)
                recognizedPoints.append(fingers[.thumbTip]!)
                recognizedPoints.append(fingers[.indexTip]!)
            }
            
            fingerTips = recognizedPoints.filter {
                $0.confidence > trackingConfidence
            }
            .map {
                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
        } catch {
            print("Error tracking hand: \(error.localizedDescription)")
            cameraFeedSession?.stopRunning()
        }
    }
}
