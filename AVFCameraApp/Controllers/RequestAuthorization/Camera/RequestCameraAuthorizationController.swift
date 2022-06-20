//
//  RequestCameraAuthorizationController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 19.06.2022.
//

import Foundation
import AVFoundation

enum CameraAuthorazationStatus {
  case granted
  case notRequested
  case unauthorized
}

typealias RequestCameraAuthorizationCompletionHandler = (CameraAuthorazationStatus) -> Void

/// Controller for checking of camera request status
class RequestCameraAuthorizationController {

  /// Requests for user's camera device access
  static func requestCameraAuthorization(completion: @escaping RequestCameraAuthorizationCompletionHandler) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      DispatchQueue.main.async {
        guard granted else {
          completion(.unauthorized)
          return
        }
        completion(.granted)
      }
    }
  }

  /// Returns current device access status is it has already been granteg or not
  static func getCameraAuthorazationStatus() -> CameraAuthorazationStatus {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .notDetermined:
      return.notRequested
    case .authorized:
      return.granted
    default:
      return .unauthorized
    }
  }
}
