//
//  FilterViewModel.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 1.03.2024.
//

import Foundation

class FilterViewModel {
  private weak var view: FilterView?
  var selectedBrands: [String] = []
  var selectedModels: [String] = []
  var sections: [FilterSection] = []

  init(view: FilterView?, items: [Item], brands: [String], models: [String]) {
    self.view = view
    createFilterItems(items: items, brands: brands, models: models)
  }

  func selectFilterAttributes(header: String, title: String) {
    if header == "Brand" {
      if selectedBrands.contains(title) {
        selectedBrands.removeAll(where: { $0 == title })
      } else {
        selectedBrands.append(title)
      }
    } else if header == "Model" {
      if selectedModels.contains(title) {
        selectedModels.removeAll(where: { $0 == title })
      } else {
        selectedModels.append(title)
      }
    }
  }

  private func createFilterItems(items: [Item], brands: [String], models: [String]) {
    var brandList: [String] = []
    var modelList: [String] = []
    items.forEach { item in
      if !brandList.contains(item.brand) {
        brandList.append(item.brand)
      }
      if !modelList.contains(item.model) {
        modelList.append(item.model)
      }
    }
    selectedBrands = brands
    selectedModels = models
    sections.append(
      .init(
        header: "Brand",
        type: .check,
        items: brandList.map { FilterSectionItem(title: $0, isChecked: brands.contains($0)) }
      )
    )
    sections.append(
      .init(
        header: "Model",
        type: .check,
        items: modelList.map { FilterSectionItem(title: $0, isChecked: models.contains($0)) }
      )
    )
    view?.updateUI()
  }
}
