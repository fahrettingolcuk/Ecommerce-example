//
//  ListinViewMock.swift
//  EcommerceTests
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

@testable import Ecommerce

final class ListingViewMock: ListingView {
  enum Invocation: Equatable {
    case updateUI
    case setLoader(Bool)
    case setEmptyView(Bool)
  }

  var invocations: [Invocation] = []
  func updateUI() {
    invocations.append(.updateUI)
  }

  func setEmptyView(_ state: Bool) {
    invocations.append(.setEmptyView(state))
  }

  func setLoader(_ state: Bool) {
    invocations.append(.setLoader(state))
  }
}
