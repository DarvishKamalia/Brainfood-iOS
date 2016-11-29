//
//  ShoppingListDataSource.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/13/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let cellReuseIdentifier = "shoppingListCell"
}

class ShoppingListDataSource : NSObject,  UITableViewDataSource  {
    private (set) var items : [String] = []
    private var purchasedItems : [String] = []
    
    override init() {
        super.init()
        #if DEBUG
            items = ["Eggs", "Milk", "Bread", "Tomatoes", "Pasta", "Chicken"]
            return
        #endif
        
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) else {
            fatalError("Could not load cell for shopping list viewcontroller")
        }
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // MARK: - Managing Item State
    
    func addItem (item: String) {
        items.append(item)
    }
    
    func removeItem (atIndex index: Int) {
        items.remove(at: index)
    }
    
    func purchaseItem(atIndex index: Int) {
        purchasedItems.append(items[index])
    }
    
    func saveItems() {
        
    }
    
    
}