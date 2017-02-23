//
//  Recipe.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/29/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

class Recipe: Equatable, FeedItem {
    
    let name: String
    let imageUrl: URL?
    let linkUrl: URL?
    
    let ingredients: [String]
    
    init (name: String, imageUrl: URL? = nil, linkUrl: URL? = nil, ingredients: [String] = []) {
        self.name = name
        self.imageUrl = imageUrl
        self.linkUrl = linkUrl
        self.ingredients = ingredients
    }
    
    init?(from json: JSON) {
        guard let name = json["title"].string else { return nil }
        
        self.name = name
        
        let id = json["id"].number?.int64Value
        imageUrl = URL(string: "http://d27bfab0aa6b39479cb3-cb8f43ffb46322cff58594e95a13ac65.r29.cf5.rackcdn.com/\(id ?? 0).jpg")
        linkUrl = json["url"].url
        
        let used = json["uses"].array?.flatMap { $0.string } ?? []
        let remaining = json["needs"].array?.flatMap { $0.string } ?? []
        ingredients = used + remaining
    }
    
    // MARK: - FeedItem variables
    
    var titleString: String {
        return name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var subtitleString : String {
        return "$" + String (arc4random() % 10)
    }
    
}

func ==(lhs: Recipe, rhs: Recipe) -> Bool {
    return lhs.name == rhs.name
        && lhs.imageUrl == rhs.imageUrl
        && lhs.linkUrl == rhs.linkUrl
        && lhs.ingredients == rhs.ingredients
}
