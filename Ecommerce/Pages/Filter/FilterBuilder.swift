//
//  FilterBuilder.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

import Foundation
import UIKit

protocol FilterBuilding {
  func view(items: [Item], delegate: FilterAttributesDelegate?, brands: [String], models: [String]) -> UIViewController
}

struct FilterBuilder: FilterBuilding {
  func view(items: [Item], delegate: FilterAttributesDelegate?, brands: [String], models: [String]) -> UIViewController {
    let view = FilterViewController()
    let viewModel = FilterViewModel(view: view, items: items, brands: brands, models: models)
    view.viewModel = viewModel
    view.delegate = delegate
    return view
  }
}
