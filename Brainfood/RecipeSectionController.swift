//
//  RecipeSectionController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/22/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit
import SafariServices
import RealmSwift

final class RecipeSectionController: IGListSectionController, IGListSectionType {
    
    var recipe: Recipe?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        var width = collectionContext?.containerSize.width ?? 0
        width = max(width - inset.left - inset.right, 0.0)
        
        return CGSize(width: width, height: 140.0)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard
            let recipe = recipe,
            let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: "Recipe", for: self, at: index) as? RecipeCell
        else { return UICollectionViewCell() }

        cell.configure(for: recipe)
        cell.delegate = self
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        recipe = object as? Recipe
    }
    
    func didSelectItem(at index: Int) {
        guard let urlString = recipe?.linkUrl, let url = URL(string: urlString) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        UIApplication.shared.keyWindow?.rootViewController?.present(safariViewController, animated: true, completion: nil)
    }
    
}

extension RecipeSectionController: RecipeCellDelegate {
    
    func recipeCell(_ cell: RecipeCell, didSelectWarningLabelFor recipe: Recipe) {
        let alertController = UIAlertController(title: "Recipe Ingredients", message: nil, preferredStyle: .alert)
        
        let ingredientsTableViewController = IngredientsViewController(style: .plain)
        ingredientsTableViewController.ingredients = recipe.ingredients
        alertController.setValue(ingredientsTableViewController, forKey: "contentViewController")
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    func recipeCell(_ cell: RecipeCell, didSelectSaveLabelFor recipe: Recipe) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(recipe)
        }
    }
    
}
