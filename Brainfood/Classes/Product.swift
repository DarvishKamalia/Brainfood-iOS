//
//  Product.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

class Product {
    let name: String
    var imageURL: NSURL?
    
    init (name: String, imageURL: String? = nil) {
        self.name = name
        
        if let urlString = imageURL {
            self.imageURL = NSURL(string: urlString)
        }
    }
}
