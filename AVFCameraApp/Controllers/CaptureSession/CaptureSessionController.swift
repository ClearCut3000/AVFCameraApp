//
//  CaptureSessionController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import Foundation
import AVFoundation

class CaptureSessionController: NSObject {

  //MARK: - Properties
  private lazy var captureSession = AVCaptureSession()

  //MARK: - Init's
  override init() {
    super.init()
    initializeCaptureSession()
  }

  //MARK: - Methods
  func getCaptureSession() -> AVCaptureSession {
    return captureSession
  }
}

//MARK: - Video Capture Device Extension
private extension CaptureSessionController {
  func getVideoCaptureDevice() -> AVCaptureDevice? {
    if let tripleCamera = AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back) {
      return tripleCamera
    }
    if let dualWideCamera = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) {
      return dualWideCamera
    }
    if let dualCamera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
      return dualCamera
    }
    if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
      return wideAngleCamera
    }
    return nil
  }

  func getCaptureDeviceInput(captureDevice: AVCaptureDevice) -> AVCaptureDeviceInput? {
    do {
      let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
      return captureDeviceInput
    } catch let error {
      print("Failed to get capture device input with error - \(error)")
    }
    return nil
  }

  func initializeCaptureSession() {
    guard let captureDevice = getVideoCaptureDevice() else { return }
    guard let captureDeviceInput = getCaptureDeviceInput(captureDevice: captureDevice) else { return }
    guard captureSession.canAddInput(captureDeviceInput) else { return }
    captureSession.addInput(captureDeviceInput)
    captureSession.startRunning()
  }
}
