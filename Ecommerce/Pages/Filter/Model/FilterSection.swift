//
//  FilterSection.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import Foundation

struct FilterSection {
  enum FilterType {
    case option
    case check
  }

  let header: String
  let type: FilterType
  var items: [FilterSectionItem]
}

struct FilterSectionItem {
  let title: String
  var isChecked: Bool
}
