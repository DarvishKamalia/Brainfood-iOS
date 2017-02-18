//
//  RecipeCell.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/18/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import Nuke

class RecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    override func prepareForReuse() {
        heroImageView.image = nil
        titleLabel?.text = nil
        descriptionLabel?.text = nil
    }
    
    func configure(for recipe: Recipe) {
        if let heroImageUrl = recipe.imageURL {
            Nuke.loadImage(with: heroImageUrl, into: heroImageView)
        } else {
            // placeholder image
        }
        
        titleLabel?.text = recipe.titleString
        descriptionLabel?.text = recipe.subtitleString
    }
    
}
