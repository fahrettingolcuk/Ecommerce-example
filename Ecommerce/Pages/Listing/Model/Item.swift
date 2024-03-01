//
//  Item.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

struct Item {
  let id: String
  let title: String
  let description: String
  let image: String
  let price: Double
  let brand: String
  let model: String
}

extension Item {
  static var mock: Item {
    .init(id: "0", title: "title", description: "", image: "iphone", price: 15000, brand: "", model: "")
  }

  static func mock(id: String) -> Item {
    .init(id: id, title: "title", description: "", image: "iphone", price: 15000, brand: "", model: "")
  }

  static func mock(brand: String) -> Item {
    .init(id: "id", title: "title", description: "", image: "iphone", price: 15000, brand: brand, model: "")
  }

  static func mock(model: String) -> Item {
    .init(id: "id", title: "title", description: "", image: "iphone", price: 15000, brand: "brand", model: model)
  }
}
