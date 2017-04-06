//
//  CartPrice.swift
//  Brainfood
//
//  Created by Darvish on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation

//
//  Product.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation
import SwiftyJSON
import IGListKit

class CartPrice: Equatable, FeedItem, IGListDiffable {
    
    let storeName: String
    var imageUrl: String
    let totalPrice: Double
    
    init (storeName: String, imageUrl: String = "", totalPrice: Double) {
        self.storeName = storeName
        self.imageUrl = imageUrl
        self.totalPrice = totalPrice
    }
    
    init? (fromJSON json: JSON) {
        guard
            let name = json["storeName"].string,
            let price = json["totalCartPrice"].double
        else {
            return nil
        }
        
        self.storeName = name
        self.totalPrice = price
        imageUrl = json["imageURL"].string ?? ""
    }
    
    // MARK: - FeedItem variables
    
    var titleString: String {
        return storeName
    }
    
    var subtitleString : NSAttributedString {
       return NSAttributedString(string: "$\(totalPrice)")
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return (storeName + "\(totalPrice)") as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return self == (object as? CartPrice)
    }
}

func ==(lhs: CartPrice, rhs: CartPrice) -> Bool {
    return lhs.storeName == rhs.storeName
        && lhs.imageUrl == rhs.imageUrl
        && lhs.totalPrice == rhs.totalPrice
}

