//
//  NetworkManagerMock.swift
//  EcommerceTests
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

@testable import Ecommerce
import Foundation

struct NetworkManagerMock: NetworkManaging {
  var response: [ProductResponse] = []
  func genericRequest<T>(url: String, type: T.Type) async throws -> T? {
    return response as? T
  }
}
