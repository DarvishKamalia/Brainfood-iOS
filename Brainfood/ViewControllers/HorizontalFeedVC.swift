//
//  HorizontalFeedVC.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/2/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit


class HorizontalFeedVC : UICollectionViewController {
    
    let items : [FeedItem]
    
    init (items : [FeedItem]) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.items = items
        super.init(collectionViewLayout: layout)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewController Methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
