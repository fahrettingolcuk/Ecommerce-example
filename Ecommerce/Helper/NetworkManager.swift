//
//  NetworkManager.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import Foundation

protocol NetworkManaging {
  func genericRequest<T: Codable>(url: String, type: T.Type) async throws -> T?
}

struct NetworkManager: NetworkManaging {
  enum NetworkError: Error {
    case undefined
    case badUrl
  }

  func genericRequest<T: Codable>(url: String, type: T.Type) async throws -> T? {
    guard let url = URL(string: url) else { throw NetworkError.badUrl }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let fetchedData = try JSONDecoder().decode(T.self, from: data)
      return fetchedData
    } catch {
      throw NetworkError.undefined
    }
  }
}
