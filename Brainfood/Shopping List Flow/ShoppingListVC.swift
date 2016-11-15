//
//  ShoppingListVC.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/13/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class ShoppingListVC: UITableViewController {
    var dataSource: ShoppingListDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ShoppingListDataSource()
        tableView.dataSource = dataSource
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dataSource.saveItems()
        dismiss(animated: true, completion: nil)
    }

    //UITableView Delegate Methods 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dataSource.purchaseItem(atIndex: indexPath.row)
    }
}
