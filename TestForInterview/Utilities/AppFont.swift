//
//  AppFont.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 29.10.2025.
//

import UIKit
import SwiftUI

enum AppFontType {
  case regual
  case medium
  case semibold
  case bold
  
  var name: String {
    switch self {
    case .regual: "Roboto-Regular"
    case .medium: "Roboto-Medium"
    case .semibold: "Roboto-SemiBold"
    case .bold: "Roboto-Bold"
    }
  }
}

struct AppFont {
  static func font(type: AppFontType, size: Int) -> UIFont {
    return UIFont(name: type.name, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
  }
}

extension View {
  func setFont(type: AppFontType, size: CGFloat) -> some View {
    return self.font(.custom(type.name, size: size))
  }
}
