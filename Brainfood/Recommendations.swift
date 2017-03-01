//
//  Recommendations.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit

class Recommendations: Equatable, IGListDiffable {
    
    var items: [Product]
    
    init(items: [Product]) {
        self.items = items
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return items.first?.diffIdentifier() ?? NSObject()
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return self == (object as? Recommendations)
    }
    
}

func ==(lhs: Recommendations, rhs: Recommendations) -> Bool {
    return lhs.items == rhs.items
}
