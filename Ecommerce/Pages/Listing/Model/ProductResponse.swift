//
//  ProductResponse.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

struct ProductResponse: Codable {
  let name: String
  let id: String
  let image: String
  let price: String
  let description: String
  let model: String
  let brand: String
  let createdAt: String
}

extension ProductResponse {
  static func mock(title: String) -> ProductResponse {
    .init(name: title, id: "", image: "", price: "", description: "", model: "", brand: "", createdAt: "")
  }

  static func mock(brand: String) -> ProductResponse {
    .init(name: "", id: "", image: "", price: "", description: "", model: "", brand: brand, createdAt: "")
  }

  static var mock: ProductResponse {
    .init(name: "", id: "", image: "", price: "", description: "", model: "", brand: "", createdAt: "")
  }
}
