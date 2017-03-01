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
        
    @IBOutlet weak var recommendationsView: UIView!
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    lazy var apiClient: APIClient = {
        return APIClient()
    }()
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    var dataSource = [IGListDiffable]()
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let _ = apiClient.fetchRecommendations(type: .Deals, forItems: ShoppingCart.shared.cartItems).then { items -> Void in
//            let vc = HorizontalFeedVC(items: items, title: "Deals based on your shopping cart")
//            self.addChildViewController(vc)
//            vc.view.frame = CGRect(x: 0, y: 20, width: self.recommendationsView.frame.width, height: self.recommendationsView.frame.size.height)
//            self.recommendationsView.addSubview(vc.view)
//            vc.didMove(toParentViewController: self)
//            
//            self.viewDetail = .expanded
//        }
        
        setupAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

