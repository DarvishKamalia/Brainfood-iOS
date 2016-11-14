//
//  ShoppingListDataSource.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/13/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class ShoppingListDataSource : UITableViewDataSource  {
    private var items : [String] = []
    
    func addItem (item: String) {
        items.append(item)
    }
    
    func removeItem (atIndex index: String) {
        items
    }
    

    
}
