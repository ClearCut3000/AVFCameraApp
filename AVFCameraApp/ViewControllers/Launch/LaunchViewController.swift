//
//  LaunchViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 19.06.2022.
//

import UIKit

class LaunchViewController: UIViewController {

  //MARK: - Properties
  private var requestCameraAuthorizationView: RequestCameraAuthorizationView?
  private var requestMicrophoneAuthorizationView: RequestMicrophoneAuthorizationView?
  private var requestPhotoLibraryAuthorizationView: RequestPhotoLibraryAuthorizationView?

  private var cameraAuthorizationStatus = RequestCameraAuthorizationController.getCameraAuthorazationStatus() {
    didSet {
      setupViewForNextAuthorizationRequest()
    }
  }
  private var microphoneAuthorizationStatus = RequestMicrophoneAuthorizationController.getMicrophoneAuthorazationStatus() {
    didSet {
      setupViewForNextAuthorizationRequest()
    }
  }
  private var photoLibraryAuthorizationStatus = RequestPhotoLibraryAuthorizationController.getPhotoLibraryAuthorazationStatus() {
    didSet {
      setupViewForNextAuthorizationRequest()
    }
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewForNextAuthorizationRequest()
  }
}

//MARK: - Setting View & View Control
private extension LaunchViewController {
  /// If permission is not received, then configure the view for the next authorization request
  func setupViewForNextAuthorizationRequest() {
    guard cameraAuthorizationStatus == .granted else {
      setupRequestCameraAuthorizationView()
      return
    }
    if let _ = requestCameraAuthorizationView {
      removeRequestCameraAuthorizationView()
      return
    }
    guard microphoneAuthorizationStatus == .granted else {
      setupRequestMicrophoneAuthorizationView()
      return
    }
    if let _ = requestMicrophoneAuthorizationView {
      removeRequestMicrophoneAuthorizationView()
      return
    }
    guard photoLibraryAuthorizationStatus == .granted else {
      setupRequestPhotoLibraryAuthorizationView()
      return
    }
    if let _ = requestPhotoLibraryAuthorizationView {
      removeRequestPhotoLibraryAuthorizationView()
      return
    }
    DispatchQueue.main.async {
      AppSetup.loadCaptureViewController()
    }
  }

  // Dealing with the Camera
  func setupRequestCameraAuthorizationView() {
    guard requestCameraAuthorizationView == nil else {
      if cameraAuthorizationStatus == .unauthorized {
        requestCameraAuthorizationView?.configureForErrorState()
      }
      return
    }
    let requestCameraAuthorizationView = RequestCameraAuthorizationView()
    requestCameraAuthorizationView.translatesAutoresizingMaskIntoConstraints = false
    requestCameraAuthorizationView.delegate = self
    view.addSubview(requestCameraAuthorizationView)
    NSLayoutConstraint.activate([
      requestCameraAuthorizationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      requestCameraAuthorizationView.topAnchor.constraint(equalTo: view.topAnchor),
      requestCameraAuthorizationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      requestCameraAuthorizationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    if cameraAuthorizationStatus == .unauthorized {
      requestCameraAuthorizationView.configureForErrorState()
    }
    requestCameraAuthorizationView.animateInViews()
    self.requestCameraAuthorizationView = requestCameraAuthorizationView
  }

  func removeRequestCameraAuthorizationView() {
    guard let requestCameraAuthorizationView = requestCameraAuthorizationView else { return }
    requestCameraAuthorizationView.animateOutViews(completion: { [weak self] in
      guard let self = self else { return }
      requestCameraAuthorizationView.removeFromSuperview()
      self.requestCameraAuthorizationView = nil
      self.setupViewForNextAuthorizationRequest()
    })
  }

  // Dealing with the Microphone
  func setupRequestMicrophoneAuthorizationView() {
    guard requestMicrophoneAuthorizationView == nil else {
      if microphoneAuthorizationStatus == .unauthorized {
        requestMicrophoneAuthorizationView?.configureForErrorState()
      }
      return
    }
    let requestMicrophoneAuthorizationView = RequestMicrophoneAuthorizationView()
    requestMicrophoneAuthorizationView.translatesAutoresizingMaskIntoConstraints = false
    requestMicrophoneAuthorizationView.delegate = self
    view.addSubview(requestMicrophoneAuthorizationView)
    NSLayoutConstraint.activate([
      requestMicrophoneAuthorizationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      requestMicrophoneAuthorizationView.topAnchor.constraint(equalTo: view.topAnchor),
      requestMicrophoneAuthorizationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      requestMicrophoneAuthorizationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    if microphoneAuthorizationStatus == .unauthorized {
      requestMicrophoneAuthorizationView.configureForErrorState()
    }
    requestMicrophoneAuthorizationView.animateInViews()
    self.requestMicrophoneAuthorizationView = requestMicrophoneAuthorizationView
  }

  func removeRequestMicrophoneAuthorizationView() {
    guard let requestMicrophoneAuthorizationView = requestMicrophoneAuthorizationView else { return }
    requestMicrophoneAuthorizationView.animateOutViews(completion: { [weak self] in
      guard let self = self else { return }
      requestMicrophoneAuthorizationView.removeFromSuperview()
      self.requestMicrophoneAuthorizationView = nil
      self.setupViewForNextAuthorizationRequest()
    })
  }

  // Dealing with the Photo Library
  func setupRequestPhotoLibraryAuthorizationView() {
    guard requestPhotoLibraryAuthorizationView == nil else {
      if photoLibraryAuthorizationStatus == .unauthorized {
        requestPhotoLibraryAuthorizationView?.configureForErrorState()
      }
      return
    }
    let requestPhotoLibraryAuthorizationView = RequestPhotoLibraryAuthorizationView()
    requestPhotoLibraryAuthorizationView.translatesAutoresizingMaskIntoConstraints = false
    requestPhotoLibraryAuthorizationView.delegate = self
    view.addSubview(requestPhotoLibraryAuthorizationView)
    NSLayoutConstraint.activate([
      requestPhotoLibraryAuthorizationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      requestPhotoLibraryAuthorizationView.topAnchor.constraint(equalTo: view.topAnchor),
      requestPhotoLibraryAuthorizationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      requestPhotoLibraryAuthorizationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    if photoLibraryAuthorizationStatus == .unauthorized {
      requestPhotoLibraryAuthorizationView.configureForErrorState()
    }
    requestPhotoLibraryAuthorizationView.animateInViews()
    self.requestPhotoLibraryAuthorizationView = requestPhotoLibraryAuthorizationView
  }

  func removeRequestPhotoLibraryAuthorizationView() {
    guard let requestPhotoLibraryAuthorizationView = requestPhotoLibraryAuthorizationView else { return }
    requestPhotoLibraryAuthorizationView.animateOutViews(completion: { [weak self] in
      guard let self = self else { return }
      requestPhotoLibraryAuthorizationView.removeFromSuperview()
      self.requestPhotoLibraryAuthorizationView = nil
      self.setupViewForNextAuthorizationRequest()
    })
  }

  /// Opens user's setting if permission was not granted/not allowed initially
  func openSettings() {
    let settingsURLString = UIApplication.openSettingsURLString
    if let settingsURL = URL(string: settingsURLString) {
      UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
  }
}

//MARK: - Camera Action Button Tapped Delegate
extension LaunchViewController: RequestCameraAuthorizationViewDelegate {
  func requestCameraAuthorizationTapped() {
    if cameraAuthorizationStatus == .notRequested {
      RequestCameraAuthorizationController.requestCameraAuthorization { [weak self] status in
        guard let self = self else { return }
        self.cameraAuthorizationStatus = status
      }
      return
    }
    if cameraAuthorizationStatus == .unauthorized {
      openSettings()
      return
    }
  }
}

//MARK: - Microphone Action Button Tapped Delegate
extension LaunchViewController: RequestMicrophoneAuthorizationViewDelegate {
  func requestMicrophoneAuthorizationTapped() {
    if microphoneAuthorizationStatus == .notRequested {
      RequestMicrophoneAuthorizationController.requestMicrophoneAuthorization { [weak self] status in
        guard let self = self else { return }
        self.microphoneAuthorizationStatus = status
      }
      return
    }
    if microphoneAuthorizationStatus == .unauthorized {
      openSettings()
      return
    }
  }
}

//MARK: - Photo Library Action Button Tapped Delegate
extension LaunchViewController: RequestPhotoLibraryAuthorizationViewDelegate {
  func requestPhotoLibraryAuthorizationTapped() {
    if photoLibraryAuthorizationStatus == .notRequested {
      RequestPhotoLibraryAuthorizationController.requestPhotoLibraryAuthorization { [weak self] status in
        guard let self = self else { return }
        self.photoLibraryAuthorizationStatus = status
      }
      return
    }
    if photoLibraryAuthorizationStatus == .unauthorized {
      openSettings()
      return
    }
  }
}
