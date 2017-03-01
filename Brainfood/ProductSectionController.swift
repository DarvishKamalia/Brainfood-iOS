//
//  ProductSectionController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/27/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit
import SafariServices

final class ProductSectionController: IGListSectionController, IGListSectionType {
    
    var product: Product?
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        let sideLength = (collectionContext?.containerSize.width ?? 0.0) / 4.0
        return CGSize(width: sideLength, height: 120)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard
            let product = product,
            let cell = collectionContext?.dequeueReusableCell(withNibName: "DefaultHorizontalFeedCell", bundle: Bundle.main, for: self, at: index) as? FeedCell
            else { return UICollectionViewCell() }
        
        cell.configure(withFeedItem: product)
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        product = object as? Product
    }
    
    func didSelectItem(at index: Int) {
        if let url = product?.link {
            let safariViewController = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
