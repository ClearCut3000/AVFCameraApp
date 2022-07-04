//
//  CaptureSessionController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import Foundation
import AVFoundation
import UIKit

enum CameraType {
  case ultrawide
  case wide
  case telephoto
}

typealias CaptureSessionInitializedCompletionHandler = () -> Void

typealias CaptureSessionToggleCompletionHandler = (CameraPosition) -> Void

enum CameraPosition {
  case front
  case back
}

class CaptureSessionController: NSObject {

  //MARK: - Properties
  private lazy var captureSession = AVCaptureSession()
  private var captureDevice: AVCaptureDevice?
  private var zoomState = ZoomState.wide
  private var captureDeviceInput: AVCaptureDeviceInput?
  private var cameraPosition = CameraPosition.back
  private var previousZoomState = ZoomState.wide

  //MARK: - Init
  override init() {
    super.init()
    captureDevice = getBackVideoCaptureDevice()
  }

  //MARK: - Public Methods
  ///
  func initializeCaptureSession(captureDevice: AVCaptureDevice? = nil, completion: CaptureSessionInitializedCompletionHandler? = nil) {
    var tempCaptureDevice = self.captureDevice
    if let passedCaptureDevice = captureDevice {
      tempCaptureDevice = passedCaptureDevice
    }
    guard let captureDevice = tempCaptureDevice else { return }
    self.captureDevice = captureDevice
    guard let captureDeviceInput = getCaptureDeviceInput(captureDevice: captureDevice) else { return }
    self.captureDeviceInput = captureDeviceInput
    guard captureSession.canAddInput(captureDeviceInput) else { return }
    NotificationCenter.default.removeObserver(self,
                                              name: .AVCaptureDeviceSubjectAreaDidChange,
                                              object: captureDevice)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(subjectAreaDidChangeNotificationHandler(notification:)),
                                           name: .AVCaptureDeviceSubjectAreaDidChange,
                                           object: captureDevice)
    captureSession.addInput(captureDeviceInput)
    captureSession.startRunning()
    setVideoZoomFactor()
    completion?()
  }

  /// Returns the capture session
  func getCaptureSession() -> AVCaptureSession {
    return captureSession
  }

  /// Method sets zoom state for CaptureSessionController property
  func setZoomState(zoomState: ZoomState) {
    self.zoomState = zoomState
    setVideoZoomFactor()
  }

  /// Returns an array of available camera types for the current device
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

  /// This methods used to change camera capture session device from from to back and  back
  func toggleCamera(completion: CaptureSessionToggleCompletionHandler? = nil) {
    if let captureDeviceInput = captureDeviceInput {
      captureSession.removeInput(captureDeviceInput)
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      switch self.cameraPosition {
      case .front:
        if let backCaptureDevice = self.getBackVideoCaptureDevice() {
          self.initializeCaptureSession(captureDevice: backCaptureDevice)
        }
        self.cameraPosition = .back
        self.zoomState = self.previousZoomState
        self.setVideoZoomFactor()
      case .back:
        self.previousZoomState = self.zoomState
        self.zoomState = .wide
        if let frontCaptureDevice = self.getFrontVideoCaptureDevice() {
          self.initializeCaptureSession(captureDevice: frontCaptureDevice)
        }
        self.cameraPosition = .front
      }
      self.resetFocus()
      completion?(self.cameraPosition)
    }
  }

  /// This method is used to stop the flow of data from the inputs to the outputs connected to the AVCaptureSession instance that is the receiver.
  func stopRunning() {
    captureSession.stopRunning()
  }

  /// This method is used to start the flow of data from the inputs to the outputs connected to the AVCaptureSession instance that is the receiver.
  func startRunning() {
    captureSession.startRunning()
  }

  /// Setting up focus and exposure for point of user's interest
  func setFocus(focusMode: AVCaptureDevice.FocusMode,
                exposureMode: AVCaptureDevice.ExposureMode,
                atPoint devicePoint: CGPoint,
                shouldMonitorSubjectAreaChange: Bool) {
    guard let captureDevice = captureDevice else { return }
    do {
      try captureDevice.lockForConfiguration()
    } catch let error as NSError {
      print("Failed to get lock for configuration on capture device with error - \(error)")
      return
    }
    if captureDevice.isFocusPointOfInterestSupported, captureDevice.isFocusModeSupported(focusMode) {
      captureDevice.focusPointOfInterest = devicePoint
      captureDevice.focusMode = focusMode
    }
    if captureDevice.isExposurePointOfInterestSupported, captureDevice.isExposureModeSupported(exposureMode) {
      captureDevice.exposurePointOfInterest = devicePoint
      captureDevice.exposureMode = exposureMode
    }
    captureDevice.isSubjectAreaChangeMonitoringEnabled = shouldMonitorSubjectAreaChange
    captureDevice.unlockForConfiguration()
  }

  /// Responsible for answering the calls for the subject area changes
  @objc func subjectAreaDidChangeNotificationHandler(notification: Notification) {
    let devicePoint = CGPoint(x: 0.5, y: 0.5)
    setFocus(focusMode: .continuousAutoFocus,
             exposureMode: .continuousAutoExposure,
             atPoint: devicePoint,
             shouldMonitorSubjectAreaChange: false)
  }

  func turnOnTorch() -> Bool {
    return setTorchMode(torchMode: .on)
  }

  func turnOffTorch() -> Bool {
    return setTorchMode(torchMode: .off)
  }
}

//MARK: - Video CaptureDevice Private Extension
private extension CaptureSessionController {
  /// Returns the available rear video device
  func getBackVideoCaptureDevice() -> AVCaptureDevice? {
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

  /// Returns the available front video device
  func getFrontVideoCaptureDevice() -> AVCaptureDevice? {
    if let trueDepthCamera = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) {
      return trueDepthCamera
    }
    if let wideAngleCamera =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
      return wideAngleCamera
    }
    return nil
  }

  /// Returns the available video capture device input of type AVCaptureDeviceInput
  func getCaptureDeviceInput(captureDevice: AVCaptureDevice) -> AVCaptureDeviceInput? {
    do {
      let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
      return captureDeviceInput
    } catch let error {
      print("Failed to get capture device input with error - \(error)")
    }
    return nil
  }

  ///
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

  // Setting current torch mode
  func setTorchMode(torchMode: AVCaptureDevice.TorchMode) -> Bool {
    guard let captureDevice = captureDevice else { return false }
    do {
      try captureDevice.lockForConfiguration()
    } catch let error as NSError {
      print("Failet to get lock for configuration on capture device with error - \(error) ")
    }
    guard captureDevice.isTorchAvailable else { return false }
    captureDevice.torchMode = torchMode
    captureDevice.unlockForConfiguration()
    return true
  }

  /// Reseting focus and exposure after chnging front/back cameras
  func resetFocus() {
    let devicePoint = CGPoint(x: 0.5, y: 0.5)
    setFocus(focusMode: .continuousAutoFocus,
             exposureMode: .continuousAutoExposure,
             atPoint: devicePoint,
             shouldMonitorSubjectAreaChange: false)
  }
}
