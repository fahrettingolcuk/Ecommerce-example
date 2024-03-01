//
//  FilterViewModelTests.swift
//  EcommerceTests
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

@testable import Ecommerce
import Foundation
import XCTest

final class FilterViewModelTests: XCTestCase {
  let view = FilterViewMock()
  override class func setUp() {
    super.setUp()
  }

  override class func tearDown() {
    super.tearDown()
  }

  func testDefaultFilterAttributes() {
    let viewModel = FilterViewModel(
      view: view,
      items: [.mock, .mock, .mock, .mock, .mock],
      brands: [],
      models: []
    )
    XCTAssertEqual(view.invocations.contains(.updateUI), true)
    XCTAssertEqual(viewModel.sections.count, 2)
  }

  func testFilterAttributeBrandList() {
    let viewModel = FilterViewModel(
      view: view,
      items: [.mock(brand: "1"), .mock(brand: "2"), .mock(brand: "1"), .mock(brand: "3"), .mock(brand: "1")],
      brands: [],
      models: []
    )
    XCTAssertEqual(viewModel.sections[0].items.count, 3)
  }

  func testFilterAttributeModelList() {
    let viewModel = FilterViewModel(
      view: view,
      items: [.mock(model: "1"), .mock(model: "2"), .mock(model: "1"), .mock(model: "3"), .mock(model: "1")],
      brands: [],
      models: []
    )
    XCTAssertEqual(viewModel.sections[1].items.count, 3)
  }

  func testSelectFilterAttribute() {
    let viewModel = FilterViewModel(
      view: view,
      items: [.mock],
      brands: [],
      models: []
    )
    viewModel.selectFilterAttributes(header: "Brand", title: "1")
    XCTAssertEqual(viewModel.selectedBrands.count, 1)
    viewModel.selectFilterAttributes(header: "Brand", title: "1")
    XCTAssertEqual(viewModel.selectedBrands.count, 0)
    viewModel.selectFilterAttributes(header: "Model", title: "1")
    XCTAssertEqual(viewModel.selectedModels.count, 1)
    viewModel.selectFilterAttributes(header: "Model", title: "1")
    XCTAssertEqual(viewModel.selectedModels.count, 0)
  }
}
