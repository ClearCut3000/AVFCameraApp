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
    if let captureDevice = AVCaptureDevice.default(.builtInDualCamera,
                                                   for: .video,
                                                   position: .back) {
      if let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) {
        captureSession.addInput(deviceInput)
      }
      captureSession.startRunning()
    }
  }

  //MARK: - Methods
  func getCaptureSession() -> AVCaptureSession {
    return captureSession
  }

}
