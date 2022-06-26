//
//  CaptureViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit

class CaptureViewController: UIViewController {

  //MARK: - Properties
  private lazy var captureSessionController = CaptureSessionController()
  private var portraitConstrains = [NSLayoutConstraint]()
  private var landscapeConstrains = [NSLayoutConstraint]()
  private lazy var timerController = TimerController()

  //MARK: - Outlets
  @IBOutlet private weak var videoPreviewView: VideoPreviewView!
  @IBOutlet private weak var recordView: RecordView!
  @IBOutlet private weak var timerView: TimerView!

  //MARK: - Layout
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    setupOrienationConstraits(size: size)
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    videoPreviewView.videoPreviewLayer.session = captureSessionController.getCaptureSession()
    initializeConstraits()
    setupTimer()
  }

  //MARK: - Methods
  func setupTimer() {
    timerController.setupTimer { [weak self] seconds in
      guard let self = self else { return }
      self.timerView.updateTime(seconds: seconds)
      print(seconds)
    }
  }
}

//MARK: - Constraint's Extension
private extension CaptureViewController {
  func initializeConstraits() {
    portraitConstrains = [
      recordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
      recordView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ]
    landscapeConstrains = [
      recordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
      recordView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
    let screenSize = UIScreen.main.bounds.size
    setupOrienationConstraits(size: screenSize)
  }

  func setupOrienationConstraits(size: CGSize) {
    if size.width > size.height {
      // landscape orientation
      NSLayoutConstraint.deactivate(portraitConstrains)
      NSLayoutConstraint.activate(landscapeConstrains)
    } else {
      // portrait orientation
      NSLayoutConstraint.deactivate(landscapeConstrains)
      NSLayoutConstraint.activate(portraitConstrains)
    }
  }
}
