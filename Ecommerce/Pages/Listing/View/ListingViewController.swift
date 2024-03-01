//
//  ListingViewController.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

final class ListingViewController: UIViewController {
  var viewModel: ListingViewModel?

  private lazy var loadingIndicator: UIAlertController = {
    let alert = UIAlertController(title: nil, message: "Please Wait", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = .large
    loadingIndicator.startAnimating()
    alert.view.addSubview(loadingIndicator)
    return alert
  }()

  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    label.numberOfLines = 1
    label.text = "No data"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: .fontXXL, weight: .bold)
    label.sizeToFit()
    return label
  }()

  private lazy var searchBar: UISearchBar = {
    let search = UISearchBar()
    search.placeholder = "Search products"
    search.delegate = self
    search.translatesAutoresizingMaskIntoConstraints = false
    return search
  }()

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
    setupView()
    addButtonToNavBar()
  }

  // Dismiss and reload badge & product
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.reloadData()
    updateTabBar()
  }
}

private extension ListingViewController {
  func setupView() {
    view.addSubview(searchBar)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacing16),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacing16),
      searchBar.heightAnchor.constraint(equalToConstant: 50),
      collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: .spacing12),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    view.backgroundColor = .white
  }
}

extension ListingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let viewModel = viewModel else { return 0 }
    return viewModel.items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProductCell.reuseIdentifier,
      for: indexPath
    ) as? ProductCell,
      let item = viewModel?.items[indexPath.row]
    else { return UICollectionViewCell() }
    cell.configure(item: item)
    cell.onTap = { [weak self] product, isIncrement in
      CartManager.sharedInstance.action(with: product, type: isIncrement ? .increase : .decrease)
      let indexPath = IndexPath(item: indexPath.row, section: 0)
      collectionView.reloadItems(at: [indexPath])
      self?.updateTabBar()
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = viewModel?.items[indexPath.row] else { return }
    let detail = DetailViewController()
    detail.updateUI(item: item)
    detail.modalPresentationStyle = .currentContext
    present(detail, animated: true)
  }
}

// MARK: Navigation & tab bar

extension ListingViewController {
  func updateTabBar() {
    tabBarController?.tabBar.items?[1].badgeValue = "\(CartManager.sharedInstance.itemCount)"
  }

  func addButtonToNavBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(tapFilter))
  }

  @objc func tapFilter() {
    guard let viewModel = viewModel else { return }
    let filter = UINavigationController(
      rootViewController: FilterBuilder().view(
        items: viewModel.allItems,
        delegate: self,
        brands: viewModel.filterAttributes.0,
        models: viewModel.filterAttributes.1
      ))
    filter.modalPresentationStyle = .formSheet
    present(filter, animated: true)
  }
}

extension ListingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let count = viewModel?.items.count,
          let viewModel = viewModel
    else { return }
    if indexPath.row == count - 1 && !viewModel.isLoading {
      viewModel.loadMore()
    }
  }
}

extension ListingViewController: ListingView {
  func updateUI() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
      self.dismiss(animated: true)
    }
  }

  func setEmptyView(_ state: Bool) {
    if state {
      showEmptyState()
    } else {
      hideEmptyState()
    }
  }

  func setLoader(_ state: Bool) {
    if state {
      DispatchQueue.main.async {
        self.present(self.loadingIndicator, animated: true, completion: nil)
      }
    } else {
      DispatchQueue.main.async {
        self.dismiss(animated: true)
      }
    }
  }
}

extension ListingViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let viewModel = viewModel else { return }
    viewModel.isSearchActive = !searchText.isEmpty
    viewModel.searchedItems(text: searchText)
  }
}

private extension ListingViewController {
  func showEmptyState() {
    view.addSubview(emptyLabel)
    emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  func hideEmptyState() {
    emptyLabel.removeFromSuperview()
  }
}

extension ListingViewController: FilterAttributesDelegate {
  func applyAttributes(brands: [String], models: [String]) {
    viewModel?.setFilterItems(brands: brands, models: models)
  }
}
