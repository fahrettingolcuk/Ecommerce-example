//
//  ListingViewDelegate.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

protocol ListingView: AnyObject {
  func updateUI()
  func setEmptyView(_ state: Bool)
  func setLoader(_ state: Bool)
}

protocol FilterAttributesDelegate: AnyObject {
  func applyAttributes(brands: [String], models: [String])
}
