//
//  DetailBuilder.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import Foundation
import UIKit

protocol DetailBuilding {
  func view(item: Item) -> UIViewController
}

struct DetailBuilder: DetailBuilding {
  func view(item: Item) -> UIViewController {
    let view = DetailViewController()
    return view
  }
}
