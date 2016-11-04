//
//  HorizontalFeedVC.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/2/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let DefaultHorizontalFeedCellNibName = "DefaultHorizontalFeedCell"
    static let cellReuseIdentifier = "FeedCell"
}

class HorizontalFeedVC : UICollectionViewController {
    
    let items : [FeedItem]
    
    init (items : [FeedItem]) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.items = items
        super.init(collectionViewLayout: layout)
        
        collectionView?.register(UINib(nibName: Constants.DefaultHorizontalFeedCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewController Methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? FeedCell else {
            fatalError("Could not load cell for collectionView")
        }
        
        cell.configure(withFeedItem: items[indexPath.row])
        return cell 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
