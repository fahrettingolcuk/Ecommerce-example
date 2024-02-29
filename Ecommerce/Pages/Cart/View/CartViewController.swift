//
//  CartViewController.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

class CartViewController: UIViewController {
  private let listCollectionViewFlowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = .spacing16
    layout.minimumLineSpacing = .spacing12
    let width = (UIScreen.main.bounds.width - .spacing16)
    layout.itemSize = .init(width: width, height: 60)
    return layout
  }()

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: listCollectionViewFlowLayout
  )

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
    label.text = "Total:"
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

  private lazy var completeButton: UILabel = {
    let label = UILabel()
    label.backgroundColor = .systemBlue
    label.text = "Complete"
    label.textColor = .white
    label.textAlignment = .center
    label.font = .systemFont(ofSize: .fontXL, weight: .bold)
    label.clipsToBounds = true
    label.layer.cornerRadius = 8
    return label
  }()

  private lazy var bottomStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [totalPriceStack, completeButton])
    stack.axis = .horizontal
    stack.spacing = .spacing8
    stack.distribution = .fillEqually
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    view.addSubview(bottomStack)
    NSLayoutConstraint.activate([
      bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacing12),
      bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacing12),
      bottomStack.heightAnchor.constraint(equalToConstant: 60)
    ])
  }

  // Dismiss and reload badge & product
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.reloadData()
    priceView.text = "\(CartManager.sharedInstance.getTotalPriceAllProduct()) ₺"
    updateTabBar()
  }
}

private extension CartViewController {
  func setupCollectionView() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CartItemView.self, forCellWithReuseIdentifier: CartItemView.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.pinToSuperView()
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension CartViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    CartManager.sharedInstance.itemList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CartItemView.reuseIdentifier,
      for: indexPath
    ) as? CartItemView
    else { return UICollectionViewCell() }
    cell.configure(product: CartManager.sharedInstance.itemList[indexPath.row])
    cell.onTap = { [weak self] product, isIncrement in
      CartManager.sharedInstance.action(with: product, type: isIncrement ? .increase : .decrease)
      collectionView.reloadData()
      self?.priceView.text = "\(CartManager.sharedInstance.getTotalPriceAllProduct()) ₺"
      self?.updateTabBar()
    }
    return cell
  }
}

// MARK: Tabbar

extension CartViewController {
  func updateTabBar() {
    tabBarController?.tabBar.items?[1].badgeValue = "\(CartManager.sharedInstance.itemCount)"
  }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {}
