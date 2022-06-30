//
//  CaptureSessionController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import Foundation
import AVFoundation

enum CameraType {
  case ultrawide
  case wide
  case telephoto
}

typealias CaptureSessionInitializedCompletionHandler = () -> Void

class CaptureSessionController: NSObject {

  //MARK: - Properties
  private lazy var captureSession = AVCaptureSession()
  private var captureDevice: AVCaptureDevice?
  private var zoomState = ZoomState.wide

  //MARK: - Init
  init(completion: @escaping CaptureSessionInitializedCompletionHandler) {
    super.init()
    initializeCaptureSession(completion: completion)
  }

  //MARK: - Methods
  func getCaptureSession() -> AVCaptureSession {
    return captureSession
  }

  func setZoomState(zoomState: ZoomState) {
    self.zoomState = zoomState
    setVideoZoomFactor()
  }

  func getCameraTypes() -> [CameraType]? {
    guard let captureDevice = captureDevice else { return nil }
    switch captureDevice.deviceType {
    case .builtInTripleCamera:
      return [.ultrawide, .wide, .telephoto]
    case .builtInDualWideCamera:
      return [.ultrawide, .wide]
    case .builtInDualCamera:
      return [.wide, .telephoto]
    case .builtInWideAngleCamera:
      return [.wide]
    default:
      return nil
    }
  }
}

//MARK: - Video CaptureDevice Extension
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

  func initializeCaptureSession(completion: @escaping CaptureSessionInitializedCompletionHandler) {
    guard let captureDevice = getVideoCaptureDevice() else { return }
    self.captureDevice = captureDevice
    guard let captureDeviceInput = getCaptureDeviceInput(captureDevice: captureDevice) else { return }
    guard captureSession.canAddInput(captureDeviceInput) else { return }
    captureSession.addInput(captureDeviceInput)
    captureSession.startRunning()
    setVideoZoomFactor()
    completion()
  }

  func setVideoCaptureDeviceZoom(videoZoomFactor: CGFloat, animated: Bool = false, rate: Float = 0) {
    guard let captureDevice = captureDevice else { return }
    do {
      try captureDevice.lockForConfiguration()
    } catch let error {
      print("Failed to get lock configuration on capture device with error - \(error)")
      return
    }
    if animated {
      captureDevice.ramp(toVideoZoomFactor: videoZoomFactor, withRate: rate)
    } else {
      captureDevice.videoZoomFactor = videoZoomFactor
    }
    captureDevice.unlockForConfiguration()
  }

  func getVideoZoomFactor() -> CGFloat {
    switch zoomState {
    case .ultrawide:
      return 1
    case .wide:
      return getWideVideoZoomFactor()
    case .telephoto:
      return getTelephotoVideoZoomFactor()
    }
  }

  func getWideVideoZoomFactor() -> CGFloat {
    guard let captureDevice = captureDevice else { return 1 }
    switch captureDevice.deviceType {
    case .builtInTripleCamera:
      return 3
    case .builtInDualWideCamera:
      return 2
    default:
      return 1
    }
  }

  func getTelephotoVideoZoomFactor() -> CGFloat{
    guard let captureDevice = captureDevice else { return 2 }
    switch captureDevice.deviceType {
    case .builtInTripleCamera:
      return 3
    case .builtInDualWideCamera:
      return 2
    default:
      return 2
    }
  }

  func setVideoZoomFactor() {
    let videoZoomFactor = getVideoZoomFactor()
    setVideoCaptureDeviceZoom(videoZoomFactor: videoZoomFactor)
  }
}
