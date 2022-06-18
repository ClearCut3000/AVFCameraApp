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

  //MARK: - Method's
  private func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  //MARK: - Action's
  @IBAction func actionButtonHandler(button: UIButton) {
    delegate?.requestCameraAuthorizationTapped()
  }
}
