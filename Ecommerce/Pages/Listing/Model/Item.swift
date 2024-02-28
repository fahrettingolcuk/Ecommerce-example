//
//  Item.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

struct Item {
  let id: String
  let title: String
  let description: String
  let image: String
  let price: Double
}

extension Item {
  static var mock: Item {
    .init(id: "0", title: "iPhone", description: "Minima quas corrupti delectus. Pariatur itaque at. Voluptate expedita unde excepturi dolores quasi quis. Delectus occaecati quaerat iusto nihil reiciendis voluptatem excepturi illum.\nVoluptatem qui ullam quas commodi ullam. Incidunt atque excepturi eveniet id consectetur maxime quia suscipit minima. Dicta excepturi molestiae dolore neque. Repellat minus sit inventore amet delectus omnis. Corrupti dolorem quam occaecati quisquam.\nVoluptatibus dolore quos dolorem nemo iste ipsa totam quisquam odio. Eveniet enim animi adipisci iusto sit eveniet. Provident soluta maxime voluptatum accusamus consectetur nostrum sequi atque. Sunt doloribus quibusdam quia maxime vero ad accusantium. Esse animi velit velit aliquid itaque voluptatem.", image: "iphone", price: 15000)
  }

  static func mock(id: String) -> Item {
    .init(id: id, title: "iPhone", description: "Minima quas corrupti delectus. Pariatur itaque at. Voluptate expedita unde excepturi dolores quasi quis. Delectus occaecati quaerat iusto nihil reiciendis voluptatem excepturi illum.\nVoluptatem qui ullam quas commodi ullam. Incidunt atque excepturi eveniet id consectetur maxime quia suscipit minima. Dicta excepturi molestiae dolore neque. Repellat minus sit inventore amet delectus omnis. Corrupti dolorem quam occaecati quisquam.\nVoluptatibus dolore quos dolorem nemo iste ipsa totam quisquam odio. Eveniet enim animi adipisci iusto sit eveniet. Provident soluta maxime voluptatum accusamus consectetur nostrum sequi atque. Sunt doloribus quibusdam quia maxime vero ad accusantium. Esse animi velit velit aliquid itaque voluptatem.", image: "iphone", price: 15000)
  }
}
