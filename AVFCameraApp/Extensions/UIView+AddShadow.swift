//
//  UIView+AddShadow.swift
//  AVFCameraApp
//
//  Created by Николай Никитин on 22.06.2022.
//

import UIKit

extension UIView {
  func addShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 10
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 5, height: 10)
    layer.masksToBounds = true
    layer.cornerRadius = 4
    
  }
}
