//
//  HomeViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/14/17.
//  Copyright © 2017 Ayush Saraswat. All rights reserved.
//

import UIKit
import IGListKit

class DiscoverViewController: UIViewController, UIScrollViewDelegate, IGListAdapterDataSource, IGListAdapterDelegate {
        
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView(text: "Hold tight, we're fetching some recipes we know you'll like.")
    }()
    
    var dataSource = [IGListDiffable]()
    var loading = false

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadRecipes()
    }
    
    // MARK: - Setup
    
    func setupAdapter() {
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
        
        adapter.dataSource = self
        adapter.delegate = self
    }
    
    // MARK: - Data Sources
    
    func loadRecipes() {
        let items = ShoppingCart.shared.cartItems.map { Product(name: $0) }
        APIClient.shared
            .getRecipes(forItems: items, index: dataSource.count)
            .then { recipes -> Void in
                recipes.forEach {
                    self.dataSource.append($0)
                }
            }
            .catch { error in
                print(error)
            }
            .always(on: DispatchQueue.main) {
                self.loading = false
                self.adapter.performUpdates(animated: true, completion: nil)
        }
    }

    // MARK: - IGListAdapterDataSource

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case is Recipe:
            return RecipeSectionController()
        default:
            return IGListSectionController()
        }
        
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return loadingView
    }
    
    func listAdapter(_ listAdapter: IGListAdapter!, willDisplay object: Any!, at index: Int) {
        
    }
    
    func listAdapter(_ listAdapter: IGListAdapter!, didEndDisplaying object: Any!, at index: Int) {
        
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 {
            loading = true
            self.loadRecipes()
        }
    }
    
}

