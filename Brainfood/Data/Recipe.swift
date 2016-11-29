//
//  Recipe.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/29/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

class Recipe : FeedItem {
    let name: String
    var imageURL: URL?
    var linkURL: URL?
    var ingredients: [String] = []
    
    init (name: String, imageURL: String? = nil, linkURL: String? = nil) {
        self.name = name
        
        if let imageURLString = imageURL {
            self.imageURL = URL(string: imageURLString)
        }
        
        if let linkURLString = linkURL {
            self.linkURL = URL(string: linkURLString)
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
            let imageURLString = json["image"] as? String,
            let imageURL = URL(string: imageURLString)
        {
            self.imageURL = imageURL
        }
        
        if let linkURLString = json["link"] as? String {
            self.linkURL = URL(string: linkURLString)
        }
        
        if let ingredients = json["ingredients"] as? [String] {
            self.ingredients = ingredients
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
