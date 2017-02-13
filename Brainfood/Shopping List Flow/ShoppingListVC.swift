//
//  FoodListTableViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 1/29/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let shoppingListUserDefaultsKey = "ShoppingList"
}

class ShoppingListViewController: UITableViewController {
    
    let client = APIClient()
    var items = [String]()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem?
    
    // MARK: - ViewController lifecycle 
    
    override func viewDidLoad() {
        if let cachedItems = UserDefaults.standard.array(forKey: Constants.shoppingListUserDefaultsKey) as? [String] {
            items = cachedItems
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    // MARK: - Actions
    
    @IBAction func dismiss() {
        UserDefaults.standard.set(self.items, forKey: Constants.shoppingListUserDefaultsKey)
        dismiss(animated: true)
    }
    
    @IBAction func add() {
        let alertController = UIAlertController(title: "Add New Item", message: "Enter item name", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] action in
            if let textField = alertController.textFields?.first {
                let itemDescription = textField.text ?? ""
                let _ = self?.client.addFoodItem(item: itemDescription)
                    .then {
                        alertController.dismiss(animated: true, completion: nil)
                    }
                    .always {
                        self?.items.append(itemDescription)
                        self?.tableView.reloadData()
                }
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addTextField { textField in
            textField.placeholder = "pineapple"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.itemDescription
        
        return cell
    }
    
    // MARK: - Delegate Methods 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deleteRows(at: [indexPath], with: .top)
    }
}
