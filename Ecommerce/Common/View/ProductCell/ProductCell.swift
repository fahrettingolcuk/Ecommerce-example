//
//  ProductCell.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import Foundation
import Kingfisher
import UIKit

final class ProductCell: UICollectionViewCell {
  var onTap: ((Item, Bool) -> Void)?
  private lazy var favoriteView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(systemName: "star.fill")
    image.tintColor = .systemYellow
    image.contentMode = .scaleAspectFit
    image.translatesAutoresizingMaskIntoConstraints = false
    image.widthAnchor.constraint(equalToConstant: 24).isActive = true
    image.heightAnchor.constraint(equalToConstant: 24).isActive = true
    return image
  }()

  private lazy var itemImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.translatesAutoresizingMaskIntoConstraints = false
    image.backgroundColor = .gray
    return image
  }()

  private lazy var itemLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontM, weight: .bold)
    label.numberOfLines = 2
    label.textColor = .black
    return label
  }()

  private lazy var priceView: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontM, weight: .bold)
    label.textColor = .systemBlue
    return label
  }()

  private lazy var addToCart: AddToCartView = {
    let view = AddToCartView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [priceView, itemLabel, addToCart])
    stack.axis = .vertical
    stack.spacing = .spacing4
    stack.distribution = .fillEqually
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(itemImage)
    addSubview(favoriteView)
    addSubview(stack)
    addToCart.onTap = { [weak self] id, isIncrement in
      self?.onTap?(id, isIncrement)
    }
    backgroundColor = .white
    NSLayoutConstraint.activate([
      favoriteView.topAnchor.constraint(equalTo: topAnchor, constant: .spacing8),
      favoriteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacing4),
      itemImage.topAnchor.constraint(equalTo: topAnchor, constant: .spacing8),
      itemImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacing4),
      itemImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacing4),
      itemImage.heightAnchor.constraint(equalToConstant: frame.height * 0.5),
      stack.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: .spacing16),
      stack.widthAnchor.constraint(equalToConstant: frame.width),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacing4),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacing4),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacing16),
      addToCart.widthAnchor.constraint(equalTo: widthAnchor, constant: -.spacing8)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 3
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}

extension ProductCell {
  func configure(item: Item) {
    itemLabel.text = item.title
    priceView.text = "\(item.price) ₺"
    let basketValue = CartManager.sharedInstance.getItem(with: item.id)
    addToCart.configure(shouldShowDefaultView: basketValue == 0, product: item)
    if item.image.isEmpty {
      itemImage.image = UIImage(named: "")
    } else {
      let url = URL(string: item.image)
      itemImage.kf.setImage(with: url)
    }
  }
}
