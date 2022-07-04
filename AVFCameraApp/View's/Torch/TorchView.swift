//
//  TorchView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 04.07.2022.
//

import UIKit

enum TorchMode {
  case off
  case on
}

protocol TorchViewDelegate: AnyObject {
  func torchTapped(torchMode: TorchMode, completion:  (Bool) -> Void)
}

class TorchView: UIView {

  //MARK: - Properties
  private var torchMode = TorchMode.off
  weak var delegate: TorchViewDelegate?

  //MARK: - Outlets
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var torchButton: UIButton!

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

  //MARK: - Action
  @IBAction func torchButtonHandler(button: UIButton) {
    delegate?.torchTapped(torchMode: torchMode, completion: { [weak self] success in
      guard let self = self else { return }
      guard success else { return }
      switch self.torchMode {
      case .off:
        self.torchButton.tintColor = .selected
        self.torchMode = .on
      case .on:
        self.torchButton.tintColor = .textOnBackgroundAlpha
        self.torchMode = .off
      }
    })
  }
}
