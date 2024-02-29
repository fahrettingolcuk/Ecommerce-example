//
//  TabViewController.swift
//  Ecommerce
//
//  Created by Fahrettin Gölcük on 28.02.2024.
//

import UIKit

class TabViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let cartVC = UINavigationController(rootViewController: CartViewController())
    cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 1)
    cartVC.tabBarItem.badgeValue = "\(CartManager.sharedInstance.itemCount)"
    let listingVC = UINavigationController(rootViewController: ListingBuilder().view())
    listingVC.tabBarItem = UITabBarItem(title: "Listing", image: UIImage(systemName: "star.fill"), tag: 2)
    self.viewControllers = [listingVC, cartVC]
  }
}
