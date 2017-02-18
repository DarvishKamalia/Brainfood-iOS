//
//  HomeViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/14/17.
//  Copyright © 2017 Ayush Saraswat. All rights reserved.
//

import UIKit
import ARCollectionViewMasonryLayout

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [RecipeSection] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var apiClient: APIClient = {
        return APIClient()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        let _ = client.fetchRecommendations(type: .PurchaseHistory).then { items -> Void in
        //            let vc = HorizontalFeedVC(items: items, title: "Based on your shopping list")
        //            self.addChildViewController(vc)
        //            vc.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 200)
        //            self.scrollView.addSubview(vc.view)
        //            vc.didMove(toParentViewController: self)
        //        }
        //
        //
        //        let _ = client.fetchRecommendations(type: .Recipes).then { recipes -> Void in
        //            let vc = HorizontalFeedVC(items: recipes, title: "Recipes that use items in your list")
        //            self.addChildViewController(vc)
        //            vc.view.frame = CGRect(x: 0, y: 220, width: self.view.frame.width, height: 200)
        //            self.scrollView.addSubview(vc.view)
        //            vc.didMove(toParentViewController: self)
        //        }
        
        configureLayout()
        loadRecipes()
    }
    
    // MARK: - Configure Layout
    
    func configureLayout() {
//        guard let waterfallLayout = ARCollectionViewMasonryLayout(direction: .vertical) else { return }
//        waterfallLayout.minimumLineSpacing = 10
//        waterfallLayout.minimumInteritemSpacing = 10
//        collectionView.setCollectionViewLayout(waterfallLayout, animated: false)
    }
    
    // MARK: - Initialize Data Sources
    
    func loadRecipes() {
        let eggs = Product(name: "eggs")
        let _ = apiClient.getRecipes(forItems: [eggs]).then { recipes -> Void in
            let recipeSection = RecipeSection(title: "Recipes matching eggs.", recipes: recipes)
            self.dataSource.append(recipeSection)
        }
        
        let milk = Product(name: "milk")
        let _ = apiClient.getRecipes(forItems: [milk]).then { recipes -> Void in
            let recipeSection = RecipeSection(title: "Recipes matching milk.", recipes: recipes)
            self.dataSource.append(recipeSection)
        }
        
        let flour = Product(name: "flour")
        let _ = apiClient.getRecipes(forItems: [flour]).then { recipes -> Void in
            let recipeSection = RecipeSection(title: "Recipes matching flour.", recipes: recipes)
            self.dataSource.append(recipeSection)
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
    
    // MARK: - Masonry Layout Delegate
    
//    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: ARCollectionViewMasonryLayout!, variableDimensionForItemAt indexPath: IndexPath!) -> CGFloat {
//        return CGFloat((indexPath.row * 30 % 120) + 80)
//    }
    
}

struct RecipeSection {
    let title: String
    let recipes: [Recipe]
}
