//
//  HorizontalCollectionViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import IGListKit

class HorizontalCollectionViewController: UIViewController, IGListAdapterDataSource, IGListAdapterDelegate {
    
    lazy var collectionView: IGListCollectionView = {
        return IGListCollectionView(frame: .zero, collectionViewLayout: HorizontalFlowLayout())
    }()
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var loadingView: LoadingView? = nil
    
    var items: [FeedItem] = [] {
        didSet {
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)

        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.frame
    }
    
    // MARK: - IGListAdapterDataSource
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if object is Product {
            loadingView = LoadingView(text: "Fetching deals from online retailers")
            return ProductSectionController()
        }
        else if object is CartPrice {
            loadingView = LoadingView(text: "Getting estimated total price from retailers")
            return CartPriceSectionController()
        }
        return IGListSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return loadingView
    }
    
    func listAdapter(_ listAdapter: IGListAdapter!, willDisplay object: Any!, at index: Int) {
        
    }
    
    func listAdapter(_ listAdapter: IGListAdapter!, didEndDisplaying object: Any!, at index: Int) {
        
    }
    
}
