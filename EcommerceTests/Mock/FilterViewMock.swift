//
//  FilterViewMock.swift
//  EcommerceTests
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

@testable import Ecommerce

final class FilterViewMock: FilterView {
  enum Invocation: Equatable {
    case updateUI
  }

  var invocations: [Invocation] = []
  func updateUI() {
    invocations.append(.updateUI)
  }
}
