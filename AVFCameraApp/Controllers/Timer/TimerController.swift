//
//  TimerController.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 26.06.2022.
//

import Foundation

typealias TimerUpdateHandler = (Int64) -> Void

class TimerController {

  //MARK: - Properties
  private var timer: Timer?
  private var seconds: Int64 = 0

  //MARK: - Methods
  func setupTimer(timerUpdateHandler: @escaping TimerUpdateHandler) {
    let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
      guard let self = self else { return }
      self.seconds += 1
      timerUpdateHandler(self.seconds)
    }
    self.timer = timer
  }

  func resetTimer() {
    timer?.invalidate()
    timer = nil
  }
}
