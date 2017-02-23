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
    var msrp: Double?
    var salePrice: Double?
    
    init (name: String, imageUrl: URL? = nil) {
        self.name = name
        self.imageUrl = imageUrl
    }
    
    init? (fromJSON json: JSON) {
        guard let name = json["name"].string else { return nil }
        
        self.name = name
        imageUrl = json["imageURL"].url
        msrp = json["msrp"].double
        salePrice = json["salePrice"].double
    }
    
    // MARK: - FeedItem variables
    
    var titleString: String {
        return name
    }
    
    var subtitleString : NSAttributedString {
        if let price = msrp,
           let sale = salePrice {
            let result = NSMutableAttributedString(string: "$")
            result.append(NSAttributedString(string:  "\(price)", attributes: [NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]))
            result.append(NSAttributedString(string: " $\(sale)"))
            return result
        }
        else if let price = salePrice {
            return NSAttributedString(string: "$\(price)")
        }
        else {
            return NSAttributedString(string:"")
        }
    }
    
}
