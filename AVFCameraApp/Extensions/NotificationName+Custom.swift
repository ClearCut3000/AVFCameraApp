//
//  NotificationName+Custom.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 30.06.2022.
//

import Foundation

extension Notification.Name {

  static var ApplicationDidBecomeActive = Notification.Name(rawValue: "ApplicationDidBecomeActive")

  static var ApplicationWillResignActive = Notification.Name(rawValue: "ApplicationWillResignActive")
}
