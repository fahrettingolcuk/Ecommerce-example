//
//  FilterSectionCell.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import UIKit

class FilterSectionCell: UICollectionViewCell {
  var sectionItem: FilterSection?
  var onSelectAttributes: ((String, String) -> Void)?
  private lazy var sectionTitle: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontXL, weight: .thin)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "Default"
    return label
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 40
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
    return tableView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(sectionTitle)
    addSubview(tableView)
    tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
    NSLayoutConstraint.activate([
      sectionTitle.topAnchor.constraint(equalTo: topAnchor, constant: .spacing12),
      sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
      sectionTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
      sectionTitle.heightAnchor.constraint(equalToConstant: sectionTitle.intrinsicContentSize.height),
      tableView.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    guard let sectionItem = sectionItem else { return .zero }
    var targetSize = targetSize
    targetSize.height = CGFloat((sectionItem.items.count * 40) + 24)
    let size = super.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
    return size
  }
}

extension FilterSectionCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sectionItem?.items.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: FilterCell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell,
          let item = sectionItem
    else { return UITableViewCell() }
    cell.configure(item: item.items[indexPath.row])
    cell.isUserInteractionEnabled = true
    return cell
  }
}

extension FilterSectionCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    self.sectionItem?.items[indexPath.row].isChecked.toggle()
    guard let sectionItem = sectionItem else { return }
    onSelectAttributes?(sectionItem.header, sectionItem.items[indexPath.row].title)
    tableView.reloadData()
  }
}

extension FilterSectionCell {
  func configure(item: FilterSection) {
    sectionItem = item
    sectionTitle.text = item.header
    tableView.reloadData()
  }
}
