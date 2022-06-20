//
//  LaunchViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 19.06.2022.
//

import UIKit

class LaunchViewController: UIViewController {

  //MARK: - Propertie's
  private var requestCameraAuthorizationView: RequestCameraAuthorizationView?
  private var cameraAuthorizationStatus = RequestCameraAuthorizationController.getCameraAuthorazationStatus() {
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
  func setupViewForNextAuthorizationRequest() {
    guard cameraAuthorizationStatus == .granted else {
      setupRequestCameraAuthorizationView()
      return
    }
    if let _ = requestCameraAuthorizationView {
      removeRequestCameraAuthorizationView()
      return
    }
  }

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

  func openSettings() {
    let settingsURLString = UIApplication.openSettingsURLString
    if let settingsURL = URL(string: settingsURLString) {
      UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
  }
}

//MARK: - Action Button Tapped Delegate
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
