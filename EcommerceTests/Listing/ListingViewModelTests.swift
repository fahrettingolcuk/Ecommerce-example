//
//  ListingViewModelTests.swift
//  EcommerceTests
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

@testable import Ecommerce
import Foundation
import XCTest

final class ListingViewModelTests: XCTestCase {
  let view = ListingViewMock()
  var networkManager = NetworkManagerMock()
  override class func setUp() {
    super.setUp()
  }

  override class func tearDown() {
    super.tearDown()
  }

  func testGetProducts() {
    networkManager.response = [.mock, .mock, .mock]
    let viewModel = ListingViewModel(view: view, networkManager: networkManager)
    let expect = XCTestExpectation()
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      XCTAssertEqual(self.view.invocations.contains(.updateUI), true)
      XCTAssertEqual(self.view.invocations.contains(.setLoader(true)), true)
      XCTAssertEqual(self.view.invocations.contains(.setLoader(false)), true)
      expect.fulfill()
    }
    wait(for: [expect], timeout: 4.0)
  }

  func testSearchProducts() {
    networkManager.response = [.mock(title: "1"), .mock(title: "2"), .mock(title: "3"), .mock(title: "4")]
    let viewModel = ListingViewModel(view: view, networkManager: networkManager)
    let expect = XCTestExpectation()
    expect.fulfill()
    wait(for: [expect], timeout: 4.0)
    viewModel.searchedItems(text: "")
    XCTAssertEqual(viewModel.items.count, 4)
    viewModel.searchedItems(text: "1")
    XCTAssertEqual(viewModel.items.count, 1)
  }

  func testFilterProducts() {
    networkManager.response = [.mock(brand: "1"), .mock(brand: "2"), .mock(brand: "3"), .mock(brand: "4")]
    let viewModel = ListingViewModel(view: view, networkManager: networkManager)
    let expect = XCTestExpectation()
    expect.fulfill()
    wait(for: [expect], timeout: 4.0)
    viewModel.setFilterItems(brands: ["1", "2"], models: [])
    XCTAssertEqual(viewModel.items.count, 2)
    viewModel.setFilterItems(brands: ["1"], models: [])
    XCTAssertEqual(viewModel.items.count, 1)
    viewModel.setFilterItems(brands: [], models: [])
    XCTAssertEqual(viewModel.items.count, 4)
  }
}
