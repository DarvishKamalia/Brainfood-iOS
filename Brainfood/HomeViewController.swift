//
//  HomeViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/14/17.
//  Copyright © 2017 Ayush Saraswat. All rights reserved.
//

import UIKit
import IGListKit

class HomeViewController: UIViewController, UIScrollViewDelegate, IGListAdapterDataSource, IGListAdapterDelegate {
        
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    lazy var apiClient: APIClient = {
        return APIClient()
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView(text: "Hold tight, we're fetching some recipes we know you'll like.")
    }()
    
    var dataSource = [IGListDiffable]()
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (ShoppingCart.shared.cartItems.isEmpty) {
            let alert = UIAlertController(title: "Welcome", message: "Add some items to your grocery list to get started", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to list", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "showGroceryList", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
        
        loadRecommendations()
        loadRecipes()
    }
    
    func setupAdapter() {
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
        
        adapter.dataSource = self
        adapter.delegate = self
    }

    // MARK: - IGListAdapterDataSource

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case _ as Recommendations:
            let controller = RecommendationsSectionController()
            controller.adapter = adapter
            return controller
        case _ as Recipe:
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
    
    // MARK: - Initialize Data Sources

    func loadRecipes() {
        let items = ShoppingCart.shared.cartItems.map { Product(name: $0) }
        apiClient
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
    
    func loadRecommendations() {
        apiClient
            .fetchRecommendations(type: .Deals, forItems: ShoppingCart.shared.cartItems)
            .then { items -> Void in
                let items = items.flatMap { $0 as? Product }
                if let existingRecommendations = self.dataSource.first as? Recommendations {
                    existingRecommendations.items.append(contentsOf: items)
                    self.dataSource[0] = existingRecommendations
                } else {
                    self.dataSource.insert(Recommendations(items: items), at: 0)
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
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 {
            loading = true
            self.loadRecipes()
        }
    }
    
}

