//
//  CaptureViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit

class CaptureViewController: UIViewController {

  //MARK: - Properties
  private var captureSessionController = CaptureSessionController()
  private var portraitConstrains = [NSLayoutConstraint]()
  private var landscapeConstrains = [NSLayoutConstraint]()
  private lazy var timerController = TimerController()
  private var switchZoomViewWidthConstraint: NSLayoutConstraint?
  private var switchZoomViewHeightConstraint: NSLayoutConstraint?
  private var shouldHideSwitchZoomView = false

  //MARK: - Outlets
  @IBOutlet private weak var videoPreviewView: VideoPreviewView!
  @IBOutlet private weak var recordView: RecordView!
  @IBOutlet private weak var timerView: TimerView!
  @IBOutlet private weak var switchZoomView: SwitchZoomView!
  @IBOutlet private weak var toggleCameraView: ToggleCameraView!
  @IBOutlet private weak var visualEffectView: UIVisualEffectView!

  //MARK: - Layout
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    hideViewsBeforeOrientationChange()
    coordinator.animate(alongsideTransition: { [weak self] context in
      guard let self = self else { return }
      self.setupVideoOrientation()
    }) { [weak self] context in
      guard let self = self else { return }
      self.setupOrienationConstraits(size: size)
      self.showViewsAfterOrientationChange()
    }
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVisualEffectView()
    setupToggleCameraView()
    setupCaptureSessionController()
    registerForApplicationStateNotifications()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initializeConstraits()
    showInitialViews()
  }

  deinit {
    NotificationCenter.default.removeObserver(self, name: .ApplicationDidBecomeActive, object: nil)
    NotificationCenter.default.removeObserver(self, name: .ApplicationWillResignActive, object: nil)
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
        reduceSwitchZoomViewSize()
      }
      if cameraTypes.filter({ $0 == CameraType.telephoto }).isEmpty {
        switchZoomView.hideTelephotoButton()
        reduceSwitchZoomViewSize()
      }
      if cameraTypes == [.wide] {
        switchZoomView.isHidden = true
        shouldHideSwitchZoomView = true
      }
    }
  }

  private func setupCaptureSessionController() {
    captureSessionController.initializeCaptureSession(completion: { [weak self] in
      guard let self = self else { return }
      self.videoPreviewView.videoPreviewLayer.session = self.captureSessionController.getCaptureSession()
      self.setupVideoOrientation()
      self.setupToggleCameraView()
      self.setupSwitchZoomView()
    })
  }

  private func setupToggleCameraView() {
    toggleCameraView.delegate = self
  }

  private func setupVisualEffectView() {
    visualEffectView.effect = nil
  }

  private func registerForApplicationStateNotifications() {
    // When App become active
    NotificationCenter.default.addObserver(forName: .ApplicationDidBecomeActive,
                                           object: nil,
                                           queue: .main) { [weak self] notification in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self.visualEffectView.effect = nil
      } completion: { _ in }
      self.captureSessionController.startRunning()
    }
    // when App goes to inactive state
    NotificationCenter.default.addObserver(forName: .ApplicationWillResignActive,
                                           object: nil,
                                           queue: .main) { [weak self] notification in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self.visualEffectView.effect = UIBlurEffect(style: .dark)
      } completion: { _ in }
    }
    self.captureSessionController.stopRunning()
  }

  private func setupVideoOrientation() {
    guard let interfaceOrientation = AppSetup.interfaceOrientation else { return }
    guard let videoOrientation = VideoOrientationController.getVideoOrientation(interfaceOrientation: interfaceOrientation) else { return }
    videoPreviewView.videoPreviewLayer.connection?.videoOrientation = videoOrientation
  }

  private func showInitialViews() {
    recordView.isHidden = false
    if !shouldHideSwitchZoomView {
      switchZoomView.isHidden = false
    }
    toggleCameraView.isHidden = false
  }
}

//MARK: - Constraint's Extension
private extension CaptureViewController {
  func initializeConstraits() {
    portraitConstrains = [
      recordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
      recordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      switchZoomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      switchZoomView.heightAnchor.constraint(equalToConstant: 60),
      switchZoomView.bottomAnchor.constraint(equalTo: recordView.topAnchor, constant: -30),
      toggleCameraView.centerYAnchor.constraint(equalTo: recordView.centerYAnchor),
      toggleCameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
    ]
    landscapeConstrains = [
      recordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
      recordView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      switchZoomView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      switchZoomView.widthAnchor.constraint(equalToConstant: 60),
      switchZoomView.trailingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: -30),
      toggleCameraView.centerXAnchor.constraint(equalTo: recordView.centerXAnchor),
      toggleCameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
    ]

    let switchZoomViewWidthConstraint = switchZoomView.widthAnchor.constraint(equalToConstant: 160)
    portraitConstrains.append(switchZoomViewWidthConstraint)
    self.switchZoomViewWidthConstraint = switchZoomViewWidthConstraint

    let switchZoomViewHeightConstraint = switchZoomView.heightAnchor.constraint(equalToConstant: 160)
    landscapeConstrains.append(switchZoomViewHeightConstraint)
    self.switchZoomViewHeightConstraint = switchZoomViewHeightConstraint

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

  func reduceSwitchZoomViewSize() {
    let delta: CGFloat = 50
    switchZoomViewWidthConstraint?.constant -= delta
    switchZoomViewHeightConstraint?.constant -= delta
  }
}

//MARK: - Switched Zoom Protocol
extension CaptureViewController: SwitchZoomViewDelegate {
  func switchZoomTapped(state: ZoomState) {
    captureSessionController.setZoomState(zoomState: state)
  }
}

//MARK: - Toggle Camera Button Protocol
extension CaptureViewController: ToggleCameraViewDelegate {
  func toggleCameraTapped() {
    captureSessionController.toggleCamera()
  }
}
