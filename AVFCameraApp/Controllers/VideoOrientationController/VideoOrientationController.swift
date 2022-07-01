//
//  VideoOrientationController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 01.07.2022.
//

import AVFoundation
import UIKit

class VideoOrientationController {

  static func getVideoOrientation(interfaceOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation? {
    switch interfaceOrientation {
    case .portrait:
      return .portrait
    case .portraitUpsideDown:
      return .portraitUpsideDown
    case .landscapeLeft:
      return.landscapeLeft
    case .landscapeRight:
      return .landscapeRight
    default:
      return nil
    }
  }
}
