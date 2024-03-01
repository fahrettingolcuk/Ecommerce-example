//
//  ListingBuilder.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import Foundation
import UIKit

protocol ListingBuilding {
  func view() -> UIViewController
}

struct ListingBuilder: ListingBuilding {
  func view() -> UIViewController {
    let view = ListingViewController()
    let networkManager = NetworkManager()
    let viewModel = ListingViewModel(view: view, networkManager: networkManager)
    view.viewModel = viewModel
    return view
  }
}
