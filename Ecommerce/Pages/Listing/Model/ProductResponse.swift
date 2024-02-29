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
