//
//  CartManager.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import CoreData
import Foundation
import UIKit

class CartManager {
  let entityName = "Cart"
  var context: NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
  }

  enum ActionType {
    case increase
    case decrease
  }

  private var basket: [String: Int] = [:]
  private var items: [String: Item] = [:]
  static let sharedInstance = CartManager()
  let database = DatabaseManager()

  private init() {
    guard let (items, basket) = database.fetchAllDatabase() else { return }
    items.forEach { self.items[$0.id] = $0 }
    self.basket = basket
  }

  func action(with product: Item, type: CartManager.ActionType) {
    switch type {
    case .increase:
      if hasItem(id: product.id) {
        guard let value = basket[product.id] else { return }
        basket.updateValue(value + 1, forKey: product.id)
        database.updateEntity(item: product, quantity: value + 1)
      } else {
        items[product.id] = product
        basket[product.id] = 1
        if !database.checkIfItemExist(id: product.id) {
          database.insertDatabase(item: product, quantity: 1)
        }
      }
    case .decrease:
      if hasItem(id: product.id) {
        guard let value = basket[product.id] else { return }
        basket.updateValue(value - 1, forKey: product.id)
        database.updateEntity(item: product, quantity: value - 1)
        if (value - 1) == 0 {
          basket.removeValue(forKey: product.id)
          items.removeValue(forKey: product.id)
          if database.checkIfItemExist(id: product.id) {
            database.deleteEntity(item: product)
          }
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
