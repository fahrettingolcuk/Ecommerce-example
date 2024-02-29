//
//  ListingViewModel.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 29.02.2024.
//

import Foundation

class ListingViewModel {
  var items: [Item] = []
  var allItems: [Item] = []
  var searchedItems: [Item] = []
  var edgeArray: (Int, Int) = (0, 3)
  var isLoading: Bool = false
  var isSearchActive: Bool = false
  var filterAttributes: ([String], [String]) = ([], [])
  private weak var view: ListingView?

  init(view: ListingView?) {
    self.view = view
    Task(priority: .userInitiated) {
      await getProducts()
      view?.updateUI()
    }
  }

  func getProducts() async {
    do {
      view?.setLoader(true)
      let data = try await NetworkManager().genericRequest(url: "https://5fc9346b2af77700165ae514.mockapi.io/products", type: [ProductResponse].self)
      guard let fetchedData = data else { return }
      allItems = fetchedData.map { mapToItem(product: $0) }
      items = Array(allItems[edgeArray.0 ... edgeArray.1])
      edgeArray = (edgeArray.0 + 4, edgeArray.1 + 4)
      view?.setLoader(false)
    } catch {
      print("Fetch error with", error.localizedDescription)
    }
  }

  func loadMore() {
    if edgeArray.1 < allItems.count - 1, searchedItems.isEmpty {
      isLoading = true
      items.append(contentsOf: Array(allItems[edgeArray.0 ... edgeArray.1]))
      edgeArray = (edgeArray.0 + 4, edgeArray.1 + 4)
      view?.setEmptyView(items.isEmpty)
      isLoading = false
      view?.updateUI()
    }
  }

  func searchedItems(text: String) {
    searchedItems.removeAll()
    if text.isEmpty {
      edgeArray = (0, 3)
      items = Array(allItems[edgeArray.0 ... edgeArray.1])
    } else {
      allItems.forEach { item in
        if item.title.contains(text) {
          searchedItems.append(item)
        }
      }
      items = searchedItems
    }
    view?.setEmptyView(items.isEmpty)
    view?.updateUI()
  }

  func setFilterItems(brands: [String], models: [String]) {
    searchedItems.removeAll()
    filterAttributes = (brands, models)
    if brands.isEmpty, models.isEmpty {
      items = allItems
      view?.updateUI()
      return
    }
    allItems.forEach { item in
      brands.forEach { brand in
        if item.brand.contains(brand) {
          searchedItems.append(item)
        }
      }
    }
    items = searchedItems
    view?.setEmptyView(items.isEmpty)
    view?.updateUI()
  }

  private func mapToItem(product: ProductResponse) -> Item {
    Item(id: product.id, title: product.name, description: product.description, image: product.image, price: Double(product.price) ?? 0, brand: product.brand, model: product.model)
  }
}
