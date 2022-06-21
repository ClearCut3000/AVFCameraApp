//
//  RequestPhotoLibraryAuthorizationController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import Foundation
import Photos
import UIKit

enum PhotoLibraryAuthorazationStatus {
  case granted
  case notRequested
  case unauthorized
}

typealias RequestPhotoLibraryAuthorizationCompletionHandler = (PhotoLibraryAuthorazationStatus) -> Void

/// Controller for checking of photo library request status
class RequestPhotoLibraryAuthorizationController {

  /// Requests for user's camera device access
  static func requestPhotoLibraryAuthorization(completion: @escaping RequestPhotoLibraryAuthorizationCompletionHandler) {
    PHPhotoLibrary.requestAuthorization { status in
      DispatchQueue.main.async {
        guard status == .authorized else {
          completion(.unauthorized)
          return
        }
        completion(.granted)
      }
    }
  }

  /// Returns current device access status is it has already been granteg or not
  static func getPhotoLibraryAuthorazationStatus() -> PhotoLibraryAuthorazationStatus {
    let status = PHPhotoLibrary.authorizationStatus()
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
