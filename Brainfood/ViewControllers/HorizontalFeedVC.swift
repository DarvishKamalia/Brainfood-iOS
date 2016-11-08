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
    static let cellReuseIdentifier = "feedCell"
    static let cellWidth: CGFloat = 180
}

class HorizontalFeedVC : UICollectionViewController {
    
    let items : [FeedItem]
    var layout : UICollectionViewFlowLayout
    
    init (items : [FeedItem]) {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.items = items
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UIViewControllerMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: Constants.DefaultHorizontalFeedCellNibName, bundle: nil)

        if let cView = collectionView {
            cView.register(cellNib, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
            cView.backgroundColor = UIColor.clear
        }

    }
    
    override func viewDidLayoutSubviews() {
        layout.itemSize = CGSize(width: Constants.cellWidth, height: view.bounds.height)
    }
    // MARK: - UICollectionViewController Methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? DefaultHorizontalFeedCell else {
            fatalError("Could not load cell for collectionView")
        }
        
       cell.configure(withFeedItem: items[indexPath.row])
       return cell 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
