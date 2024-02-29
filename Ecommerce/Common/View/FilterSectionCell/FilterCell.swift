//
//  FilterCell.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import UIKit

class FilterCell: UITableViewCell {
  var item: FilterSectionItem?
  private lazy var checkBox: CustomCheckbox = {
    let check = CustomCheckbox()
    check.translatesAutoresizingMaskIntoConstraints = false
    return check
  }()

  private lazy var itemLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: .fontM, weight: .bold)
    label.textColor = .black
    return label
  }()

  private lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [checkBox, itemLabel])
    stack.axis = .horizontal
    stack.spacing = .spacing16
    stack.distribution = .fillProportionally
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.isUserInteractionEnabled = true
    return stack
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    isUserInteractionEnabled = true
    addSubview(contentStack)
    contentStack.pinToSuperView(padding: 8)
    NSLayoutConstraint.activate([
      checkBox.widthAnchor.constraint(equalToConstant: 24),
      checkBox.heightAnchor.constraint(equalToConstant: 24)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension FilterCell {
  func configure(item: FilterSectionItem) {
    self.item = item
    checkBox.setCheck(item.isChecked)
    itemLabel.text = item.title
  }
}
