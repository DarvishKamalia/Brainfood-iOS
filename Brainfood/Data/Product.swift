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
    var imageUrl: URL?
    
    init (name: String, imageUrl: URL? = nil) {
        self.name = name
        self.imageUrl = imageUrl
    }
    
    init? (fromJSON json: JSON) {
        guard let name = json["name"].string else { return nil }
        
        self.name = name
        imageUrl = json["imageURL"].url
    }
    
    // MARK: - FeedItem variables
    
    var titleString: String {
        return name
    }
    
    var subtitleString : String {
        return "$" + String (arc4random() % 10)
    }
    
}
