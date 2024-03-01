//
//  AddToCartView.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

class AddToCartView: UIView {
  var onTap: ((Item, Bool) -> Void)?
  var product: Item?

  private(set) lazy var stepper: StepperView = {
    let stepper = StepperView()
    return stepper
  }()

  private(set) lazy var label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontM, weight: .bold)
    label.text = "Add to Cart"
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .blue
    addSubview(label)
    addSubview(stepper)
    label.pinToSuperView(padding: 8)
    stepper.pinToSuperView(padding: 0)
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    addGestureRecognizer(tap)
    stepper.tapDecrease = { [weak self] in
      guard let product = self?.product else { return }
      self?.onTap?(product, false)
    }
    stepper.tapIncrease = { [weak self] in
      guard let product = self?.product else { return }
      self?.onTap?(product, true)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    clipsToBounds = true
    layer.cornerRadius = 3
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    guard let product = product else { return }
    onTap?(product, true)
  }
}

extension AddToCartView {
  func configure(shouldShowDefaultView: Bool, product: Item) {
    self.product = product
    stepper.configure(value: CartManager.sharedInstance.getItem(with: product.id))
    if shouldShowDefaultView {
      label.isHidden = false
      stepper.isHidden = true
    } else {
      label.isHidden = true
      stepper.isHidden = false
    }
  }
}
