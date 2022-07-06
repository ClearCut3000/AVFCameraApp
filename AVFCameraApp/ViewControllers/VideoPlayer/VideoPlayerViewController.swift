//
//  VideoPlayerViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit
import AVKit

protocol VideoPlayerViewControllerdelegate: AnyObject {
  func videoPlayerViewControllerDismissed(videoPlayerViewController: VideoPlayerViewController)
}

class VideoPlayerViewController: AVPlayerViewController {

  //MARK: - Properties
  weak var videoPlayerViewControllerDelegate: VideoPlayerViewControllerdelegate?

  //MARK: - View Lifecycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    videoPlayerViewControllerDelegate?.videoPlayerViewControllerDismissed(videoPlayerViewController: self)
  }
}
