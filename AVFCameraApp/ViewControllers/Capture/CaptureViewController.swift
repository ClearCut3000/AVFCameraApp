//
//  CaptureViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit

class CaptureViewController: UIViewController {

  //MARK: - Properties
  private var captureSessionController: CaptureSessionController!
  private var portraitConstrains = [NSLayoutConstraint]()
  private var landscapeConstrains = [NSLayoutConstraint]()
  private lazy var timerController = TimerController()

  //MARK: - Outlets
  @IBOutlet private weak var videoPreviewView: VideoPreviewView!
  @IBOutlet private weak var recordView: RecordView!
  @IBOutlet private weak var timerView: TimerView!
  @IBOutlet private weak var switchZoomView: SwitchZoomView!

  //MARK: - Layout
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    hideViewsBeforeOrientationChange()
    coordinator.animate(alongsideTransition: {context in
      
    }) { [weak self] context in
      guard let self = self else { return }
      self.setupOrienationConstraits(size: size)
      self.showViewsAfterOrientationChange()
    }
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCaptureSessionController()
  }

  //MARK: - Methods
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  private func setupTimer() {
    timerController.setupTimer { [weak self] seconds in
      guard let self = self else { return }
      self.timerView.updateTime(seconds: seconds)
      print(seconds)
    }
  }

  private func hideViewsBeforeOrientationChange() {
    recordView.alpha = 0
    switchZoomView.alpha = 0
  }

  private func showViewsAfterOrientationChange() {
    let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
      self.recordView.alpha = 1
      self.switchZoomView.alpha = 1
    }
    animation.startAnimation()
  }

  private func setupSwitchZoomView() {
    switchZoomView.delegate = self
    if let cameraTypes = captureSessionController.getCameraTypes() {
      if cameraTypes.filter({ $0 == CameraType.ultrawide }).isEmpty {
        switchZoomView.hideUltrawideButton()
      }
      if cameraTypes.filter({ $0 == CameraType.telephoto }).isEmpty {
        switchZoomView.hideTelephotoButton()
      }
      if cameraTypes == [.wide] {
        switchZoomView.alpha = 0
      }
    }
  }

  private func setupCaptureSessionController() {
    captureSessionController = CaptureSessionController(completion: { [weak self] in
      guard let self = self else { return }
      self.videoPreviewView.videoPreviewLayer.session = self.captureSessionController.getCaptureSession()
      self.initializeConstraits()
      self.setupSwitchZoomView()
    })
  }
}

//MARK: - Constraint's Extension
private extension CaptureViewController {
  func initializeConstraits() {
    portraitConstrains = [
      recordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
      recordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      switchZoomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      switchZoomView.widthAnchor.constraint(equalToConstant: 160),
      switchZoomView.heightAnchor.constraint(equalToConstant: 60),
      switchZoomView.bottomAnchor.constraint(equalTo: recordView.topAnchor, constant: -30)
    ]
    landscapeConstrains = [
      recordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
      recordView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      switchZoomView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      switchZoomView.widthAnchor.constraint(equalToConstant: 60),
      switchZoomView.heightAnchor.constraint(equalToConstant: 160),
      switchZoomView.trailingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: -30)
    ]
    let screenSize = UIScreen.main.bounds.size
    setupOrienationConstraits(size: screenSize)
  }

  func setupOrienationConstraits(size: CGSize) {
    if size.width > size.height {
      // landscape orientation
      NSLayoutConstraint.deactivate(portraitConstrains)
      NSLayoutConstraint.activate(landscapeConstrains)
      switchZoomView.configureForLandscapeOrientation()
    } else {
      // portrait orientation
      NSLayoutConstraint.deactivate(landscapeConstrains)
      NSLayoutConstraint.activate(portraitConstrains)
      switchZoomView.configureForPortraitOrientation()
    }
  }
}

//MARK: - Switched Zoom Protocol
extension CaptureViewController: SwitchZoomViewDelegate {
  func switchZoomTapped(state: ZoomState) {
    captureSessionController.setZoomState(zoomState: state)
  }
}
