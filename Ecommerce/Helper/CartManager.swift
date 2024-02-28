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

  private init() {
    fetchAllDatabase()
  }

  func action(with product: Item, type: CartManager.ActionType) {
    switch type {
    case .increase:
      if hasItem(id: product.id) {
        guard let value = basket[product.id] else { return }
        basket.updateValue(value + 1, forKey: product.id)
        updateEntity(item: product, quantity: value + 1)
      } else {
        items[product.id] = product
        basket[product.id] = 1
        if !checkIfItemExist(id: product.id) {
          insertDatabase(item: product, quantity: 1)
        }
      }
    case .decrease:
      if hasItem(id: product.id) {
        guard let value = basket[product.id] else { return }
        basket.updateValue(value - 1, forKey: product.id)
        updateEntity(item: product, quantity: value - 1)
        if (value - 1) == 0 {
          basket.removeValue(forKey: product.id)
          items.removeValue(forKey: product.id)
          if checkIfItemExist(id: product.id) {
            deleteEntity(item: product)
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

  private func insertDatabase(item: Item, quantity: Int) {
    let cart = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    cart.setValue(item.id, forKey: "id")
    cart.setValue(item.price, forKey: "price")
    cart.setValue(quantity, forKey: "quantity")
    cart.setValue(item.title, forKey: "title")
    cart.setValue(item.description, forKey: "desc")
    cart.setValue(item.image, forKey: "image")
    try? context.save()
  }

  private func checkIfItemExist(id: String) -> Bool {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "id == \(id)")

    do {
      let count = try context.count(for: fetchRequest)
      if count > 0 {
        return true
      } else {
        return false
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return false
    }
  }

  private func deleteEntity(item: Item) {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    fetchRequest.predicate = NSPredicate(format: "id == \(item.id)")
    if let result = try? context.fetch(fetchRequest) {
      for object in result {
        context.delete(object)
      }
    }

    do {
      try context.save()
    } catch let error as NSError {
      print("Delete error with", error.localizedDescription)
    }
  }

  private func fetchAllDatabase() {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    if let result = try? context.fetch(fetchRequest) {
      for object in result {
        guard let id = object.value(forKey: "id") as? String,
              let price = object.value(forKey: "price") as? Double,
              let title = object.value(forKey: "title") as? String,
              let description = object.value(forKey: "desc") as? String,
              let image = object.value(forKey: "image") as? String,
              let quantity = object.value(forKey: "quantity") as? Int else { return }
        items[id] = Item(id: id, title: title, description: description, image: image, price: price)
        basket[id] = quantity
      }
    }
  }

  private func updateEntity(item: Item, quantity: Int) {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    fetchRequest.predicate = NSPredicate(format: "id == \(item.id)")
    if let result = try? context.fetch(fetchRequest) {
      if let item = result.first {
        item.setValue(quantity, forKey: "quantity")
      }
    }

    do {
      try context.save()
    } catch let error as NSError {
      print("Delete error with", error.localizedDescription)
    }
  }

  func deleteAllData() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.returnsObjectsAsFaults = false

    do {
      let results = try context.fetch(fetchRequest)
      for managedObject in results {
        let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
        context.delete(managedObjectData)
      }
    } catch let error as NSError {
      print("Delete all data in \(entityName) error : \(error) \(error.userInfo)")
    }
  }
}
