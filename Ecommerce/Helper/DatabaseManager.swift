//
//  DatabaseManager.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import CoreData
import Foundation
import UIKit

struct DatabaseManager {
  let entityName = "Cart"
  var context: NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
  }
  
  func insertDatabase(item: Item, quantity: Int) {
    let cart = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    cart.setValue(item.id, forKey: "id")
    cart.setValue(item.price, forKey: "price")
    cart.setValue(quantity, forKey: "quantity")
    cart.setValue(item.title, forKey: "title")
    cart.setValue(item.description, forKey: "desc")
    cart.setValue(item.image, forKey: "image")
    try? context.save()
  }
  
  func checkIfItemExist(id: String) -> Bool {
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
  
  func deleteEntity(item: Item) {
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
  
  func fetchAllDatabase() -> ([Item], [String: Int])? {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    var items: [Item] = []
    var basket: [String: Int] = [:]
    if let result = try? context.fetch(fetchRequest) {
      for object in result {
        guard let id = object.value(forKey: "id") as? String,
              let price = object.value(forKey: "price") as? Double,
              let title = object.value(forKey: "title") as? String,
              let description = object.value(forKey: "desc") as? String,
              let image = object.value(forKey: "image") as? String,
              let brand = object.value(forKey: "brand") as? String,
              let model = object.value(forKey: "model") as? String,
              let quantity = object.value(forKey: "quantity") as? Int else { return nil }
        items.append(Item(id: id, title: title, description: description, image: image, price: price, brand: brand, model: model))
        basket[id] = quantity
      }
    }
    return (items, basket)
  }
  
  func updateEntity(item: Item, quantity: Int) {
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
