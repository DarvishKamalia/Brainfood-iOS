//
//  ShoppingListVC.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/13/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class ShoppingListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = ShoppingListDataSource()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //UITableView Delegate Methods 
    

}
