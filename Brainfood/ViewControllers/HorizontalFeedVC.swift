//
//  HorizontalFeedVC.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/2/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

// MARK: - Constants 

fileprivate struct Constants {
    static let DefaultHorizontalFeedCellNibName = "DefaultHorizontalFeedCell"
    static let cellReuseIdentifier = "feedCell"
    static let headerReuseIdentifier = "headerView"
    static let cellWidth: CGFloat = 180
    static let headerHeight: CGFloat = 20
}

// MARK: - HorizontalFeedVC

class HorizontalFeedVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties 
    
    let collectionView : UICollectionView
    let items : [FeedItem]
    let headerLabel = UILabel(frame: CGRect.zero)
    var layout : UICollectionViewFlowLayout
    
    // MARK: - Initialization
    
    init (items : [FeedItem], title: String) {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionHeadersPinToVisibleBounds = true
        self.items = items
        self.collectionView = UICollectionView(frame: CGRect.zero , collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        headerLabel.text = title
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewControllerMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(headerLabel)
        configureConstraints()

        //Configure the collection view 
        
        let cellNib = UINib(nibName: Constants.DefaultHorizontalFeedCellNibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        layout.itemSize = CGSize(width: Constants.cellWidth, height: view.frame.height - Constants.headerHeight)
    }
    
    // MARK: - UICollectionViewController Methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? DefaultHorizontalFeedCell else {
            fatalError("Could not load cell for collectionView")
        }
        
       cell.configure(withFeedItem: items[indexPath.row])
       return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // MARK: - Private methods 
    
    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: Constants.headerHeight).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
