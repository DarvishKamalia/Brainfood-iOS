//
//  HomeViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/14/17.
//  Copyright © 2017 Ayush Saraswat. All rights reserved.
//

import UIKit
import FBLikeLayout
import SafariServices

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var recommendationsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [RecipeSection] = [] {
        didSet {
            guard dataSource != oldValue else { return }
            if dataSource.count == 0 {
                viewState = .loading
            } else if dataSource.count != 0 && (viewState != .loading || viewState != .ready) {
                viewState = .ready
            }
            collectionView.reloadData()
        }
    }
    
    lazy var apiClient: APIClient = {
        return APIClient()
    }()
    
    var viewState: ViewState = .loading {
        didSet {
            guard viewState != oldValue else { return }
            DispatchQueue.main.async { self.updateViewState() }
        }
    }
    
    var viewDetail: ViewDetail = .compact {
        didSet {
            guard viewDetail != oldValue else { return }
            DispatchQueue.main.async { self.updateViewDetail() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = apiClient.fetchRecommendations(type: .PurchaseHistory).then { items -> Void in
            let vc = HorizontalFeedVC(items: items, title: "Based on your shopping list")
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 20, width: self.recommendationsView.frame.width, height: self.recommendationsView.frame.size.height)
            self.recommendationsView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            
            self.viewDetail = .expanded
        }
        
        configureLayout()
        loadRecipes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadRecipes()
    }
    
    func updateViewState() {
        switch viewState {
        case .ready:
            loadingView.isHidden = true
            recommendationsView.isHidden = false
            collectionView.isHidden = false
        case .loading:
            loadingView.isHidden = false
            recommendationsView.isHidden = true
            collectionView.isHidden = true
        default:
            break
        }
        
        updateViewDetail()
    }
    
    func updateViewDetail() {
        guard viewState == .ready else { return }
        
        switch viewDetail {
        case .compact:
            recommendationsView.isHidden = true
            collectionView.isHidden = false
        case .expanded:
            recommendationsView.isHidden = false
            collectionView.isHidden = false
        }
    }
    
    // MARK: - Configure Layout
    
    func configureLayout() {
        let layout = FBLikeLayout()
        layout.minimumInteritemSpacing = 0
        layout.singleCellWidth = min(collectionView.bounds.size.width, collectionView.bounds.size.height) / 3.0
        layout.maxCellSpace = 3
        layout.forceCellWidthForMinimumInteritemSpacing = true
        layout.fullImagePercentageOfOccurrency = 10
        
        collectionView.contentInset = .zero
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Initialize Data Sources
    
    func loadRecipes() {
        var didClear = false
        ShoppingCart.shared.cartItems.forEach { item in
            let _ = apiClient.getRecipes(forItems: [Product(name: item)]).then { recipes -> Void in
                let recipeSection = RecipeSection(title: "Recipes matching \(item).", recipes: recipes)
                if !didClear {
                    didClear = true
                    self.dataSource.removeAll()
                }
                self.dataSource.append(recipeSection)
                
                self.viewState = .ready
            }
        }
        
        if ShoppingCart.shared.cartItems.isEmpty {
            self.dataSource.removeAll()
        }
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !dataSource.isEmpty else { return 0 }
        return dataSource[section].recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath) as? RecipeCell
        
        let recipe = dataSource[indexPath.section].recipes[indexPath.row]
        cell?.configure(for: recipe)
        cell?.delegate = self
        
        return cell ?? UICollectionViewCell()
    }
    
    // MARK: - Section Headers
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard !dataSource.isEmpty else { return UICollectionReusableView() }
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? RecipeHeaderView
            headerView?.configure(for: dataSource[indexPath.section].title)
            return headerView!
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard !dataSource.isEmpty else { return .zero }
        return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }
    
    // MARK: - Collection View Flow Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(arc4random_uniform(120) + 120), height: CGFloat(arc4random_uniform(120) + 120))
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = dataSource[indexPath.section].recipes[indexPath.row].linkUrl else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: RecipeCellDelegate {
    
    func recipeCell(_ cell: RecipeCell, didSelectWarningLabelFor recipe: Recipe) {
        let alertController = UIAlertController(title: "Recipe Ingredients", message: nil, preferredStyle: .alert)
        
        let ingredientsTableViewController = IngredientsViewController(style: .plain)
        ingredientsTableViewController.ingredients = recipe.ingredients
        alertController.setValue(ingredientsTableViewController, forKey: "contentViewController")
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

