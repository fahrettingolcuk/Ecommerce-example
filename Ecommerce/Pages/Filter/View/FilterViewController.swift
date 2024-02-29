//
//  FilterViewController.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import UIKit

class FilterViewController: UIViewController {
  var viewModel: FilterViewModel?
  weak var delegate: FilterAttributesDelegate?

  private let listCollectionViewFlowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = .spacing16
    layout.minimumLineSpacing = .spacing12
    layout.estimatedItemSize = .init(width: UIScreen.main.bounds.width, height: 200)
    return layout
  }()

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: listCollectionViewFlowLayout
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Filter"
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(tapDismiss))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "APPLY", style: .done, target: self, action: #selector(tapApply))
    view.addSubview(collectionView)
    collectionView.register(FilterSectionCell.self, forCellWithReuseIdentifier: FilterSectionCell.reuseIdentifier)
    collectionView.pinToSuperView(padding: 8)
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  @objc func tapDismiss() {
    dismiss(animated: true)
  }

  @objc func tapApply() {
    guard let viewModel = viewModel else { return }
    delegate?.applyAttributes(brands: viewModel.selectedBrands, models: viewModel.selectedModels)
    dismiss(animated: true)
  }
}

extension FilterViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: FilterSectionCell.reuseIdentifier,
      for: indexPath
    ) as? FilterSectionCell,
      let viewModel = viewModel
    else { return UICollectionViewCell() }
    cell.configure(item: viewModel.sections[indexPath.row])
    cell.onSelectAttributes = { header, title in
      viewModel.selectFilterAttributes(header: header, title: title)
    }
    return cell
  }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {}

extension FilterViewController: FilterView {
  func updateUI() {
    collectionView.reloadData()
  }
}
