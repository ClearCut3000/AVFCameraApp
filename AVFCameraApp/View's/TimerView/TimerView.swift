//
//  TimerView.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 23.06.2022.
//

import UIKit

class TimerView: UIView {

  //MARK: - Outlets
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var timerLabel: UILabel!

  //MARK: - Init's
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func customInit() {
    let bundle = Bundle.main
    let nibName = String(describing: Self.self)
    bundle.loadNibNamed(nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  //MARK: - Methods
  func updateTime(seconds: Int64) {
    // mm:ss
    let timeInterval = TimeInterval(integerLiteral: seconds)

    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad

    let formattedString = formatter.string(from: timeInterval) ?? "00:00"
    timerLabel.text = formattedString
  }
}
