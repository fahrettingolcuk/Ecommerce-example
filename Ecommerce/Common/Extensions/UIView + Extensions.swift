//
//  UIView + Extensions.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import Foundation
import UIKit

extension UIView {
  func pinToSuperView() {
    guard let superview = superview else {
      return
    }
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      superview.widthAnchor.constraint(equalTo: widthAnchor),
      superview.heightAnchor.constraint(equalTo: heightAnchor),
      superview.centerXAnchor.constraint(equalTo: centerXAnchor),
      superview.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  func pinToSuperView(
    padding: CGFloat
  ) {
    pinToSuperView(
      topPadding: padding,
      leadingPadding: padding,
      trailingPadding: padding,
      bottomPadding: padding
    )
  }

  func pinToSuperView(
    topPadding: CGFloat = 0,
    leadingPadding: CGFloat = 0,
    trailingPadding: CGFloat = 0,
    bottomPadding: CGFloat = 0
  ) {
    guard let superview = superview else {
      return
    }
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingPadding),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottomPadding),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailingPadding)
    ])
  }
}
