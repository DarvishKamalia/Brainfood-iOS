//
//  RecommendationsSectionController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit
import SafariServices

final class RecommendationsSectionController: IGListSectionController, IGListSectionType {
    
    var recommendations: Recommendations?
    var adapter: IGListAdapter?
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: 180)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard
            let recommendations = recommendations,
            let cell = collectionContext?.dequeueReusableCell(of: HorizontalCollectionViewCell.self, for: self, at: index) as? HorizontalCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.items = recommendations.items
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        recommendations = object as? Recommendations
    }
    
    func didSelectItem(at index: Int) {
     
    }
    
}
