//
//  IngredientsViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/22/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

class IngredientsViewController: UITableViewController {
    
    var ingredients: [String] = [] {
        didSet {
            guard ingredients != oldValue else { return }
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        let ingredient = ingredients[indexPath.row]
        cell.textLabel?.text = ingredient
        cell.accessoryType = ShoppingCart.shared.cartItems.contains(ingredient) ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        if ShoppingCart.shared.cartItems.contains(ingredient) {
            ShoppingCart.shared.remove(item: ingredient)
        } else {
            ShoppingCart.shared.add(item: ingredient)
        }
        tableView.reloadData()
    }

}
