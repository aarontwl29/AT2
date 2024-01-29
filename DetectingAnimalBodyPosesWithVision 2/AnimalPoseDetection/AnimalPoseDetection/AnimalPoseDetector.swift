/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The class containing the Vision part, which creates and performs the request and then returns
    the recognized points from VNAnimalBodyPose observations.
*/

import AVFoundation
import Vision

// The Vision part.
class AnimalPoseDetector: NSObject, ObservableObject {
    // Get the animal body joints using the VNRecognizedPoint.
    @Published var animalBodyParts = [VNAnimalBodyPoseObservation.JointName: VNRecognizedPoint]()
    
    let url = URL(string: "https://media0202376-aaea.streaming.media.azure.net/8dbb01d6-6d82-453f-888b-7d37dd298bca/5a7c3abb-9f6d-438c-8a62-5e683e584a03.ism/manifest(format=m3u8-cmaf)")!
    var player : AVPlayer!
    var timer : Timer?
    var imageOutput : AVPlayerItemVideoOutput?
    var animalBodyPoseRequest : VNDetectAnimalBodyPoseRequest!
    
    override init() {
        super.init()
        self.player = AVPlayer(url: url)
        self.player.play()
        
        let pixelBufferAttributes: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        imageOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: pixelBufferAttributes)
        player.currentItem?.add(imageOutput!)
        
        self.animalBodyPoseRequest = VNDetectAnimalBodyPoseRequest(completionHandler: detectedAnimalPose)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self,
                  let currentItem = self.player.currentItem,
                  let imageOutput = self.imageOutput else { return }
            
            let currentTime = CMTimeMakeWithSeconds(self.player.currentTime().seconds, preferredTimescale: 600)
            guard let pixelBuffer = imageOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) else { return }
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
            do {
                try imageRequestHandler.perform([self.animalBodyPoseRequest])
            } catch {
                print("Unable to perform the request: \(error).")
            }
        }
        
    }
    
    deinit {
        timer?.invalidate()
    }
    
    
    // Notify the delegate that a sample buffer was written.
//    func captureOutput(
//        _ output: AVCaptureOutput,
//        didOutput sampleBuffer: CMSampleBuffer,
//        from connection: AVCaptureConnection
//    ) {
//        // Create a new request to recognize an animal body pose.
//        let animalBodyPoseRequest = VNDetectAnimalBodyPoseRequest(completionHandler: detectedAnimalPose)
//        // Create a new request handler.
//        let imageRequestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .right)
//        do {
//            // Send the request to the request handler with a call to perform.
//            try imageRequestHandler.perform([animalBodyPoseRequest])
//        } catch {
//            print("Unable to perform the request: \(error).")
//        }
//    }

    func detectedAnimalPose(request: VNRequest, error: Error?) {
        // Get the results from VNAnimalBodyPoseObservations.
        guard let animalBodyPoseResults = request.results as? [VNAnimalBodyPoseObservation] else { return }
        // Get the animal body recognized points for the .all group.
        guard let animalBodyAllParts = try? animalBodyPoseResults.first?.recognizedPoints(.all) else { return }
        self.animalBodyParts = animalBodyAllParts
    }
}
