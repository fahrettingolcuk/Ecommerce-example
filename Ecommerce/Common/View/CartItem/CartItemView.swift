//
//  CartItemView.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

class CartItemView: UICollectionViewCell {
  var onTap: ((Item, Bool) -> Void)?
  private var product: Item?
  private lazy var itemLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXXL, weight: .bold)
    label.textColor = .black
    return label
  }()

  private lazy var itemPrice: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXL, weight: .medium)
    label.textColor = .systemBlue
    return label
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [itemLabel, itemPrice])
    stack.axis = .vertical
    stack.spacing = .spacing4
    stack.distribution = .fillEqually
    stack.alignment = .leading
    return stack
  }()

  private lazy var stepper: StepperView = {
    let stepper = StepperView()
    return stepper
  }()

  private lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [stack, stepper])
    stack.axis = .horizontal
    stack.spacing = .spacing16
    stack.distribution = .fillEqually
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(contentStack)
    contentStack.pinToSuperView(padding: 0)
    stepper.tapDecrease = { [weak self] in
      guard let product = self?.product else { return }
      self?.onTap?(product, false)
    }
    stepper.tapIncrease = { [weak self] in
      guard let product = self?.product else { return }
      self?.onTap?(product, true)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CartItemView {
  func configure(product: Item) {
    self.product = product
    itemLabel.text = product.title
    itemPrice.text = "\(product.price) ₺"
    stepper.configure(value: CartManager.sharedInstance.getItem(with: product.id))
  }
}
