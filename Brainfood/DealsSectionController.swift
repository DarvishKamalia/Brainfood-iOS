//
//  DealsSectionController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 4/5/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit
import SafariServices

final class DealsSectionController: IGListSectionController, IGListSectionType {
    
    var recommendations: Recommendations?
    
    override init() {
        super.init()
        
        minimumLineSpacing = 8.0
        minimumInteritemSpacing = 8.0
        
        inset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    func numberOfItems() -> Int {
        return recommendations?.items.count ?? 0
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        var width = collectionContext?.containerSize.width ?? 0
        width = max(width - inset.left - inset.right - minimumInteritemSpacing * 2.0, 0.0) / 3.0
        return CGSize(width: width, height: 140.0)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard
            let product = recommendations?.items[index],
            let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: "DealCell", for: self, at: index) as? DealCell
        else { return UICollectionViewCell() }
        
        cell.configure(for: product)
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        recommendations = object as? Recommendations
    }
    
    func didSelectItem(at index: Int) {
        
    }
    
}
