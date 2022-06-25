//
//  RecordView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 25.06.2022.
//

import UIKit

class RecordView: UIView {

  //MARK: - Outlet's
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var ringView: UIView!
  @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet private weak var stopView: UIView!

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
    setupContainerView()
  }

  //MARK: - Action's
  @IBAction func tapHandler(tapGestureRecognizer: UITapGestureRecognizer) {
    animateForRecording()
  }
}

//MARK: - Start/Stop recording animations & methods
private extension RecordView {
  func setupContainerView() {
    containerView.layer.borderWidth = 7
    containerView.layer.borderColor = UIColor.systemRed.cgColor
  }

  func animateForRecording() {
    ringView.alpha = 0
    stopView.isHidden = false
    stopView.alpha = 1
  }
}
