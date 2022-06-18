//
//  LaunchViewController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 19.06.2022.
//

import UIKit

class LaunchViewController: UIViewController {

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
}

//MARK: - Setting View
private extension LaunchViewController {
  func setupViews() {
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
  }
}

//MARK: - Action Button Tapped Delegate
extension LaunchViewController: RequestCameraAuthorizationViewDelegate {
  func requestCameraAuthorizationTapped() {
    RequestCameraAuthorizationController.requestCameraAuthorization { status in
      switch status {
      case .granted:
        <#code#>
      case .notRequested:
        <#code#>
      case .unauthorized:
        <#code#>
      }
    }
  }
}
