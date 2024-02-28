//
//  StepperView.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import Foundation
import UIKit

final class StepperView: UIView {
  var tapDecrease: (() -> Void)?
  var tapIncrease: (() -> Void)?
  private lazy var decreaseButton: UIButton = {
    let button = UIButton()
    button.setTitle("-", for: .normal)
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(decrease), for: .touchUpInside)
    return button
  }()

  private lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.backgroundColor = .systemBlue
    label.textColor = .white
    return label
  }()

  private lazy var increaseButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(increase), for: .touchUpInside)
    return button
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [decreaseButton, valueLabel, increaseButton])
    stack.axis = .horizontal
    stack.spacing = 0
    stack.distribution = .fillEqually
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(stack)
    stack.pinToSuperView(padding: 0)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func decrease() {
    tapDecrease?()
  }

  @objc func increase() {
    tapIncrease?()
  }
}

extension StepperView {
  func configure(value: Int) {
    valueLabel.text = "\(value)"
  }
}

#Preview {
  StepperView()
}
