//
//  CartManager.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import Foundation

class CartManager {
  enum ActionType {
    case increase
    case decrease
  }

  private var basket: [String: Int] = [:]
  private var items: [String: Item] = [:]
  static let sharedInstance = CartManager()
  private init() {}

  func action(with product: Item, type: CartManager.ActionType) {
    switch type {
    case .increase:
      if hasItem(id: product.id) {
        guard let value = basket[product.id] else { return }
        basket.updateValue(value + 1, forKey: product.id)
      } else {
        items[product.id] = product
        basket[product.id] = 1
      }
    case .decrease:
      if hasItem(id: product.id) {
        guard let value = basket[product.id] else { return }
        basket.updateValue(value - 1, forKey: product.id)
        if (value - 1) == 0 {
          basket.removeValue(forKey: product.id)
          items.removeValue(forKey: product.id)
        }
      } else {
        return
      }
    }
  }

  func getItem(with id: String) -> Int {
    return basket[id] ?? 0
  }

  func getTotalPriceProduct(with id: String) -> Double {
    guard let quantity = basket[id],
          let items = items[id] else { return 0 }
    return Double(quantity) * items.price
  }

  func getTotalPriceAllProduct() -> Double {
    var total: Double = 0
    items.forEach { item in total += getTotalPriceProduct(with: item.value.id) }
    return total
  }

  var itemCount: Int {
    basket.count
  }

  var itemList: [Item] {
    items.map { $0.value }
  }

  private func hasItem(id: String) -> Bool {
    if basket.contains(where: { $0.key == id }) {
      return true
    }
    return false
  }

  private func currentValue(id: String) -> Bool {
    if basket.contains(where: { $0.key == id }) {
      return true
    }
    return false
  }
}
