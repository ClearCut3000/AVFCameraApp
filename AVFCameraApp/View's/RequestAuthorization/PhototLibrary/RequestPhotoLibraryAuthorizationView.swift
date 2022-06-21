//
//  RequestPhotoLibraryAuthorizationView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 21.06.2022.
//

import UIKit

protocol RequestPhotoLibraryAuthorizationViewDelegate: AnyObject {
  func requestPhotoLibraryAuthorizationTapped()
}

class RequestPhotoLibraryAuthorizationView: UIView {

  //MARK: - Properties
  weak var delegate: RequestPhotoLibraryAuthorizationViewDelegate?

  //MARK: - Outlets
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var photoLibraryImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var actionButton: UIButton!
  @IBOutlet private weak var actionButtonWithConstraint: NSLayoutConstraint!

  //MARK: - Init's
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  private func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    setupActionButtonShadow()
  }

  //MARK: - Method's
  func animateInViews() {
    let viewsToAnimate = [photoLibraryImageView, titleLabel, messageLabel, actionButton]
    for (i, viewToAnimate) in viewsToAnimate.enumerated() {
      guard let view = viewToAnimate else { continue }
      view.animateInView(delay: Double(i) * 0.15)
    }
  }

  func animateOutViews(completion: @escaping () -> Void) {
    let viewsToAnimate = [photoLibraryImageView, titleLabel, messageLabel, actionButton]
    for (i, viewToAnimate) in viewsToAnimate.enumerated() {
      guard let view = viewToAnimate else { continue }
      var completionHandler: (() -> Void)? = nil
      if viewToAnimate == viewsToAnimate.last {
        completionHandler = completion
      }
      view.animateOutView(delay: Double(i) * 0.15, completion: completionHandler)
    }
  }

  func configureForErrorState() {
    titleLabel.text = "Photo Library Authorization Denied!"
    actionButton.setTitle("Open Settings", for: .normal)
    actionButtonWithConstraint.constant = 130
  }


  //MARK: - Action's
  @IBAction func actionButtonHandler(button: UIButton) {
    delegate?.requestPhotoLibraryAuthorizationTapped()
  }
}

private extension RequestPhotoLibraryAuthorizationView {
  func setupActionButtonShadow() {
    actionButton.addShadow()
  }
}
