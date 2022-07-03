//
//  AlertView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 03.07.2022.
//

import UIKit

class AlertView: UIView {

  //MARK: - Outlets
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var alertLabel: UILabel!

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

  //MARK: - Method's
  func setAlertText(text: String) {
    alertLabel.text = text
  }

}
