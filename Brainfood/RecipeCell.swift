//
//  RecipeCell.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/18/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import Nuke

protocol RecipeCellDelegate: class {
    func recipeCell(_ cell: RecipeCell, didSelectWarningLabelFor recipe: Recipe)
}

class RecipeCell: UICollectionViewCell {
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var ingredientAvailabilityImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    weak var delegate: RecipeCellDelegate?
    weak var recipe: Recipe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if tapGestureRecognizer == nil {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnWarning(gesture:)))
            ingredientAvailabilityImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    override func prepareForReuse() {
        recipe = nil
        delegate = nil
        
        heroImageView.image = nil
        ingredientAvailabilityImageView.image = nil
        titleLabel?.text = nil
        descriptionLabel?.text = nil
    }
    
    func configure(for recipe: Recipe) {
        self.recipe = recipe
        
        if let heroImageUrl = recipe.imageUrl {
            Nuke.loadImage(with: heroImageUrl, into: heroImageView)
        } else {
            // placeholder image
        }
        
        let acquiredIngredients = recipe.ingredients.filter { !ShoppingCart.shared.cartItems.contains($0) }.count == 0
        ingredientAvailabilityImageView.image = acquiredIngredients ? #imageLiteral(resourceName: "Complete") : #imageLiteral(resourceName: "Warning")
        
        titleLabel?.text = recipe.titleString
        descriptionLabel?.text = recipe.subtitleString
    }
    
    func tapOnWarning(gesture: UITapGestureRecognizer) {
        guard let recipe = recipe, recipe.ingredients.filter({ !ShoppingCart.shared.cartItems.contains($0) }).count > 0 else { return }
        delegate?.recipeCell(self, didSelectWarningLabelFor: recipe)
    }
    
}
