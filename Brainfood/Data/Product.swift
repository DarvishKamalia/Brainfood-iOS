//
//  Product.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product : FeedItem {
    let name: String
    var imageURL: URL?
    
    init (name: String, imageURL: String? = nil) {
        self.name = name
        
        if let urlString = imageURL {
            self.imageURL = URL(string: urlString)
        }
    }
    
    init? (fromJSON json: JSON) {
        
        if let name = json["name"].string {
            self.name = name
        }
        
        else {
            return nil
        }
        
        if
            let imageURLString = json["imageURL"].string,
            let imageURL = URL(string: imageURLString)
        {
            self.imageURL = imageURL
        }
    
    }
    
    // MARK: - FeedItem variables
    
    var titleString: String {
        return name
    }
    
    var subtitleString : String {
        return "$" + String (arc4random() % 10)
    }
}
