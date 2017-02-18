//
//  RecipeHeaderView.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/18/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

class RecipeHeaderView: UICollectionReusableView {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func prepareForReuse() {
        headerLabel.text = nil
    }
    
    func configure(for headerText: String) {
        headerLabel.text = headerText
    }

}
