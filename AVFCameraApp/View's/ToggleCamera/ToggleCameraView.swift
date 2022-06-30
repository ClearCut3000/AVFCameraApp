//
//  ToggleCameraView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 30.06.2022.
//

import UIKit

protocol ToggleCameraViewDelegate: AnyObject {
  func toggleCameraTapped()
}

class ToggleCameraView: UIView {

  //MARK: - Properties
  weak var delegate: ToggleCameraViewDelegate?

  //MARK: - Outlet's
  @IBOutlet private weak var contentView: UIView!

  //MARK: - Init's
  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  //MARK: - Action
  @IBAction func toggleButtonTapped(button: UIButton) {
    delegate?.toggleCameraTapped()
  }
}
