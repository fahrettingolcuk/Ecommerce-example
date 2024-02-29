//
//  Checkbox.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import UIKit

class CustomCheckbox: UIButton {
  private var isChecked: Bool = false
  private lazy var checkImage: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(systemName: "checkmark")
    image.contentMode = .scaleAspectFit
    image.tintColor = .white
    return image
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBlue
    addSubview(checkImage)
    checkImage.pinToSuperView(padding: 2)
    backgroundColor = .white
    checkImage.isHidden = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    layer.borderWidth = 2
    layer.borderColor = UIColor.systemBlue.cgColor
    layer.cornerRadius = 8
  }
}

extension CustomCheckbox {
  func toggle() {
    isChecked.toggle()
    if isChecked {
      backgroundColor = .systemBlue
      checkImage.isHidden = false
    } else {
      backgroundColor = .white
      checkImage.isHidden = true
    }
  }

  func setCheck(_ state: Bool) {
    isChecked = state
    if state {
      backgroundColor = .systemBlue
      checkImage.isHidden = false
    } else {
      backgroundColor = .white
      checkImage.isHidden = true
    }
  }
}
