/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main view controller object.
*/

import UIKit
import AVFoundation
import Vision
import SwiftUI

final class CameraViewController: UIViewController {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    private func setupPlayer() {
        guard let url = URL(string: "https://media0202376-aaea.streaming.media.azure.net/8dbb01d6-6d82-453f-888b-7d37dd298bca/5a7c3abb-9f6d-438c-8a62-5e683e584a03.ism/manifest(format=m3u8-cmaf)") else {
            print("Invalid URL")
            return
        }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }
        player?.play()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }
    

//    private var cameraSession: AVCaptureSession?
//    weak var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
//    let cameraQueue = DispatchQueue(
//        label: "CameraOutput",
//        qos: .userInitiated
//        )
//    override func loadView() {
//        view.self = CameraView()
//    }
//    var cameraView: CameraView {
//        (view as? CameraView)!
//      }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        do {
//            if cameraSession == nil {
//                try prepareAVSession()
//                cameraView.previewLayer.session = cameraSession
//                cameraView.previewLayer.videoGravity = .resizeAspectFill
//            }
//            // Starting the camera session.
//            DispatchQueue.global(qos: .background).async {
//                self.cameraSession?.startRunning()
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        cameraSession?.stopRunning()
//        super.viewWillDisappear(animated)
//    }
//    func prepareAVSession() throws {
//        let session = AVCaptureSession()
//        session.beginConfiguration()
//        session.sessionPreset = AVCaptureSession.Preset.high
//        
//        // Select the back camera as a video device.
//        guard let videoDevice = AVCaptureDevice.default(
//                .builtInWideAngleCamera,
//                for: .video,
//                position: .back)
//        else { return }
//        
//        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice)
//        else { return }
//        
//        guard session.canAddInput(deviceInput)
//        else { return }
//        
//        session.addInput(deviceInput)
//        
//        let dataOutput = AVCaptureVideoDataOutput()
//        if session.canAddOutput(dataOutput) {
//            session.addOutput(dataOutput)
//            dataOutput.setSampleBufferDelegate(delegate, queue: cameraQueue)
//        } else { return }
//        
//        session.commitConfiguration()
//        cameraSession = session
//    }
}

struct DisplayView: UIViewControllerRepresentable {
    var animalJoint: AnimalPoseDetector
    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraViewController = CameraViewController()
//        cameraViewController.delegate = animalJoint
        return cameraViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
