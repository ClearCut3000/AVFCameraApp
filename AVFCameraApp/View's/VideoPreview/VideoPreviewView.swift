//
//  VideoPreviewView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit
import AVFoundation

class VideoPreviewView: UIView {

  //MARK: - Properties
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    return layer as! AVCaptureVideoPreviewLayer
  }

  /// Returs AVCaptureVideoPreviewLayer as root layer
  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }

  //MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    videoPreviewLayer.frame = UIScreen.main.bounds
    videoPreviewLayer.videoGravity = .resizeAspect
  }
  
}
