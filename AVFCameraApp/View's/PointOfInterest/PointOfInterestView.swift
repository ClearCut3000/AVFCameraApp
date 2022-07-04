//
//  PointOfInterestView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 04.07.2022.
//

import UIKit

class PointOfInterestView: UIView {

//MARK: - Outlets
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

  private func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.layer.borderColor = UIColor.yellow.cgColor
    contentView.layer.borderWidth = 1
  }

}
