//
//  DetailViewController.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

final class DetailViewController: UIViewController {
  private enum Constants {
    static let headerHeight: CGFloat = 36
    static let imageHeight: CGFloat = UIScreen.main.bounds.height * 0.3
  }

  private lazy var backButton: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(systemName: "arrow.backward")
    image.widthAnchor.constraint(equalToConstant: Constants.headerHeight).isActive = true
    image.heightAnchor.constraint(equalToConstant: Constants.headerHeight).isActive = true
    image.isUserInteractionEnabled = true
    return image
  }()

  private lazy var header: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXL, weight: .bold)
    label.textColor = .black
    return label
  }()

  private lazy var headerStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [backButton, header])
    stack.axis = .horizontal
    stack.spacing = .spacing8
    stack.distribution = .fill
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
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
    label.font = .systemFont(ofSize: .fontXL, weight: .bold)
    label.numberOfLines = 2
    label.textColor = .black
    return label
  }()

  private lazy var itemDescription: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXL, weight: .regular)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()

  private lazy var priceView: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXL, weight: .bold)
    label.textColor = .black
    return label
  }()

  private lazy var totalLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXL, weight: .bold)
    label.textColor = .systemBlue
    label.text = "Price:"
    return label
  }()

  private lazy var totalPriceStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [totalLabel, priceView])
    stack.axis = .vertical
    stack.spacing = .spacing4
    stack.distribution = .fillEqually
    stack.alignment = .leading
    return stack
  }()

  private lazy var addToCart: AddToCartView = {
    let view = AddToCartView()
    return view
  }()

  private lazy var bottomStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [totalPriceStack, addToCart])
    stack.axis = .horizontal
    stack.spacing = .spacing8
    stack.distribution = .fillEqually
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  private lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [itemLabel, itemDescription])
    stack.axis = .vertical
    stack.spacing = .spacing8
    stack.distribution = .fill
    stack.alignment = .leading
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.setupView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissDetail))
    self.backButton.addGestureRecognizer(tap)
    self.addToCart.onTap = { [weak self] product, isIncrement in
      CartManager.sharedInstance.action(with: product, type: isIncrement ? .increase : .decrease)
      self?.tabBarController?.tabBar.items?[1].badgeValue = "\(CartManager.sharedInstance.itemCount)"
      let basketValue = CartManager.sharedInstance.getItem(with: product.id)
      self?.addToCart.configure(shouldShowDefaultView: basketValue == 0, product: product)
      if basketValue == 0 {
        self?.priceView.text = "\(product.price) ₺"
      } else {
        self?.priceView.text = "\(CartManager.sharedInstance.getTotalPriceProduct(with: product.id)) ₺"
      }
    }
  }

  func setupView() {
    view.addSubview(self.headerStack)
    view.addSubview(self.itemImage)
    view.addSubview(self.bottomStack)
    view.addSubview(self.contentStack)
    NSLayoutConstraint.activate([
      self.headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      self.headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacing8),
      self.headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      self.headerStack.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
      self.itemImage.topAnchor.constraint(equalTo: self.headerStack.bottomAnchor),
      self.itemImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacing8),
      self.itemImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacing8),
      self.itemImage.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
      self.bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      self.bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacing8),
      self.bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacing8),
      self.bottomStack.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
      self.contentStack.topAnchor.constraint(equalTo: self.itemImage.bottomAnchor),
      self.contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacing8),
      self.contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacing8),
      self.contentStack.bottomAnchor.constraint(equalTo: self.bottomStack.topAnchor, constant: -.spacing16)
    ])
  }

  @objc func dismissDetail() {
    dismiss(animated: true)
  }
}

extension DetailViewController {
  func updateUI(item: Item) {
    self.header.text = item.title
    self.itemLabel.text = item.title
    self.itemDescription.text = item.description
    let basketValue = CartManager.sharedInstance.getItem(with: item.id)
    self.addToCart.configure(shouldShowDefaultView: basketValue == 0, product: item)
    if basketValue == 0 {
      self.priceView.text = "\(item.price) ₺"
    } else {
      self.priceView.text = "\(CartManager.sharedInstance.getTotalPriceProduct(with: item.id)) ₺"
    }
    if item.image.isEmpty {
      self.itemImage.image = UIImage(named: "")
    } else {
      let url = URL(string: item.image)
      self.itemImage.kf.setImage(with: url)
    }
  }
}
