//
//  DealsViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 4/4/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import IGListKit

class DealsViewController: UIViewController, IGListAdapterDataSource, IGListAdapterDelegate {

    @IBOutlet weak var collectionView: IGListCollectionView!
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView(text: "Hold tight, we're fetching some recipes we know you'll like.")
    }()
    
    var dataSource = [IGListDiffable]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadRecommendations()
    }
    
    // MARK: - Setup
    
    func setupAdapter() {
        adapter.collectionView = collectionView
        
        adapter.dataSource = self
        adapter.delegate = self
    }
    
    // MARK: - Data Sources
    
    func loadRecommendations() {
        APIClient.shared
            .getDeals()
            .then { deals -> Void in
                let recommendations = Recommendations(items: deals)
                self.dataSource.append(recommendations)
            }
            .catch { error in
                print(error)
            }
            .always(on: DispatchQueue.main) {
                self.adapter.performUpdates(animated: true, completion: nil)
            }
    }

    // MARK: - IGListAdapterDataSource
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case is Recommendations:
            return DealsSectionController()
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

}
