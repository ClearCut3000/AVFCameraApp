//
//  RequestMicrophoneAuthorizationController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 21.06.2022.
//

import Foundation
import AVFoundation

enum MicrophoneAuthorazationStatus {
  case granted
  case notRequested
  case unauthorized
}

typealias RequestMicrophoneAuthorizationCompletionHandler = (MicrophoneAuthorazationStatus) -> Void

/// Controller for checking of microphone request status
class RequestMicrophoneAuthorizationController {

  /// Requests for user's camera device access
  static func requestMicrophoneAuthorization(completion: @escaping RequestMicrophoneAuthorizationCompletionHandler) {
    AVCaptureDevice.requestAccess(for: .audio) { granted in
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
  static func getMicrophoneAuthorazationStatus() -> MicrophoneAuthorazationStatus {
    let status = AVCaptureDevice.authorizationStatus(for: .audio)
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
