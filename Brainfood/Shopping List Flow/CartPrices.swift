//
//  CartPrices.swift
//  Brainfood
//
//  Created by Darvish on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit

class CartPrices: Equatable, IGListDiffable {
    
    var items: [CartPrice]
    
    init(items: [CartPrice]) {
        self.items = items
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return items.first?.diffIdentifier() ?? NSObject()
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return self == (object as? CartPrices)
    }
    
}

func ==(lhs: CartPrices, rhs: CartPrices) -> Bool {
    return lhs.items == rhs.items
}
