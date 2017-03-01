//
//  CartPriceSectionController.swift
//  Brainfood
//
//  Created by Darvish on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit

final class CartPriceSectionController: IGListSectionController, IGListSectionType {
    
    var cartPrice: CartPrice?
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        let sideLength = (collectionContext?.containerSize.width ?? 0.0) / 4.0
        return CGSize(width: sideLength, height: 120)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard
            let cartPrice = cartPrice,
            let cell = collectionContext?.dequeueReusableCell(withNibName: "DefaultHorizontalFeedCell", bundle: Bundle.main, for: self, at: index) as? FeedCell
            else { return UICollectionViewCell() }
        
        cell.configure(withFeedItem: cartPrice)
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        cartPrice = object as? CartPrice
    }
    
    func didSelectItem(at index: Int) {
        
    }
    
}
