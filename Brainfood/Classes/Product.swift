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
    
    init? (fromJSON json: [String : AnyObject]) {
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        else {
            return nil
        }
        
        if
            let imageURLString = json["imageURL"] as? String,
            let imageURL = NSURL(string: imageURLString)
        {
            self.imageURL = imageURL
        }
    
    }
}
