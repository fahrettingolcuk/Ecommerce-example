//
//  ListingViewController.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

let items: [Item] = [
  .mock(id: "0"),
  .mock(id: "1"),
  .mock(id: "2"),
  .mock(id: "3"),
  .mock(id: "4"),
  .mock(id: "5"),
  .mock(id: "6"),
  .mock(id: "7"),
  .mock(id: "8"),
]

class ListingViewController: UIViewController {
  private let listCollectionViewFlowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = .spacing16
    layout.minimumLineSpacing = .spacing12
    let width = (UIScreen.main.bounds.width - .spacing16) / 2
    layout.itemSize = .init(width: width, height: width * 1.7)
    return layout
  }()

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: listCollectionViewFlowLayout
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }

  // Dismiss and reload badge & product
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.reloadData()
    updateTabBar()
  }
}

private extension ListingViewController {
  func setupCollectionView() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.pinToSuperView()
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension ListingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProductCell.reuseIdentifier,
      for: indexPath
    ) as? ProductCell
    else { return UICollectionViewCell() }
    cell.configure(item: items[indexPath.row])
    cell.onTap = { [weak self] product, isIncrement in
      CartManager.sharedInstance.action(with: product, type: isIncrement ? .increase : .decrease)
      let indexPath = IndexPath(item: indexPath.row, section: 0)
      collectionView.reloadItems(at: [indexPath])
      self?.updateTabBar()
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(items[indexPath.row])
    let detail = DetailViewController()
    detail.updateUI(item: items[indexPath.row])
    detail.modalPresentationStyle = .fullScreen
    present(detail, animated: true)
  }
}

// MARK: Tabbar

extension ListingViewController {
  func updateTabBar() {
    tabBarController?.tabBar.items?[1].badgeValue = "\(CartManager.sharedInstance.itemCount)"
  }
}

extension ListingViewController: UICollectionViewDelegateFlowLayout {}
