//
//  HorizontalCollectionViewCell.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/27/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import IGListKit

final class HorizontalCollectionViewCell: UICollectionViewCell {
    
    let collectionViewController: HorizontalCollectionViewController
    let collectionView: UIView
    
    var items: [FeedItem] = [] {
        didSet {
            self.collectionViewController.items = items
        }
    }

    override init(frame: CGRect) {
        collectionViewController = HorizontalCollectionViewController()
        collectionView = collectionViewController.view
        
        super.init(frame: frame)
        
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = frame
    }
    
}
