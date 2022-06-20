//
//  RequestCameraAuthorizationView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 19.06.2022.
//

import UIKit

protocol RequestCameraAuthorizationViewDelegate: AnyObject {
  func requestCameraAuthorizationTapped()
}

class RequestCameraAuthorizationView: UIView {

  //MARK: - Properties
  weak var delegate: RequestCameraAuthorizationViewDelegate?

  //MARK: - Outlets
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var cameraImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var actionButton: UIButton!
  @IBOutlet private weak var actionButtonWithConstraint: NSLayoutConstraint!

  //MARK: - Init's
  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
    fatalError("init(coder:) has not been implemented")
  }

  private func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addActionButtonShadow()
  }

  //MARK: - Method's
  private func addActionButtonShadow() {
    actionButton.layer.shadowColor = UIColor.black.cgColor
    actionButton.layer.shadowRadius = 10
    actionButton.layer.opacity = 0.3
    actionButton.layer.masksToBounds = false
    actionButton.layer.shadowOffset = CGSize(width: 5, height: 5)
    actionButton.layer.cornerRadius = 4
  }

  func animateInViews() {
    let viewsToAnimate = [cameraImageView, titleLabel, messageLabel, actionButton]
    for (i, viewToAnimate) in viewsToAnimate.enumerated() {
      guard let view = viewToAnimate else { continue }
      animateInView(view: view, delay: Double(i) * 0.15)
    }
  }

  func animateOutViews(completion: @escaping () -> Void) {
    let viewsToAnimate = [cameraImageView, titleLabel, messageLabel, actionButton]
    for (i, viewToAnimate) in viewsToAnimate.enumerated() {
      guard let view = viewToAnimate else { continue }
      var completionHandler: (() -> Void)? = nil
      if viewToAnimate == viewsToAnimate.last {
        completionHandler = completion
      }
      animateOutView(view: view, delay: Double(i) * 0.15, completion: completionHandler)
    }
  }

  func configureForErrorState() {
    titleLabel.text = "Camera Authorization Denied!"
    actionButton.setTitle("Open Settings", for: .normal)
    actionButtonWithConstraint.constant = 120
  }

  //MARK: - Action's
  @IBAction func actionButtonHandler(button: UIButton) {
    delegate?.requestCameraAuthorizationTapped()
  }
}

//MARK: - Animation Method's
private extension RequestCameraAuthorizationView {
  func animateInView(view: UIView, delay: TimeInterval) {
    view.alpha = 0
    view.transform = CGAffineTransform(translationX: 0, y: -20)
    let animation = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
      view.alpha = 1
      view.transform = .identity
    }
    animation.startAnimation(afterDelay: delay)
  }

  func animateOutView(view: UIView, delay: TimeInterval, completion: (() -> Void)? = nil) {
    let animation = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
      view.alpha = 0
      view.transform = CGAffineTransform(translationX: 0, y: -20)
    }
    animation.addCompletion { _ in
      completion?()
    }
    animation.startAnimation(afterDelay: delay)
  }
}
