//
//  CaptureViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit

class CaptureViewController: UIViewController {

  //MARK: - Properties
  private lazy var captureSession = CaptureSessionController()

  //MARK: - Outlets
  @IBOutlet private weak var videoPreviewView: VideoPreviewView!

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

}
