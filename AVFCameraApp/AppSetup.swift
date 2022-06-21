//
//  AppSetup.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit

/// Class for Setting CaptureViewController as Root if all permissions are granted
class AppSetup {

  /// Static method for loading CaptureViewController as Root
  static func loadCaptureViewController() {
    let nibName = String(describing: CaptureViewController.self)
    let bundle = Bundle.main
    let captureViewController = CaptureViewController(nibName: nibName, bundle: bundle)
    let window = Self.keyWindow
    window?.rootViewController = captureViewController
    window?.makeKeyAndVisible()
  }

  /// Static instance for finding main window scene
  static var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
  }
}
