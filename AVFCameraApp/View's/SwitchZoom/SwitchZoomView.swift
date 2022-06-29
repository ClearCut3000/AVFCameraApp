//
//  SwitchZoomView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 29.06.2022.
//

import UIKit

enum ZoomState {
  case ultrawide
  case wide
  case telephoto
}

class SwitchZoomView: UIView {

  //MARK: - Properties
  private var zoomState = ZoomState.wide
  private var selectedButton: UIButton?

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

  private func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  //MARK: - Action's
  @IBAction func ultrawideButtonHandler(button: UIButton) {

  }

  @IBAction func wideButtonHandler(button: UIButton) {

  }

  @IBAction func telephotoButtonHandler(button: UIButton) {

  }

}
