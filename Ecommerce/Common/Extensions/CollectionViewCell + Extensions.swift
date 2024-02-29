//
//  CollectionViewCell + Extensions.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

protocol ReuseIdentifying {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
}

extension UICollectionViewCell: ReuseIdentifying {}

extension UITableViewCell: ReuseIdentifying {}
