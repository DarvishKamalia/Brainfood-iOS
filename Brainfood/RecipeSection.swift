//
//  RecipeSection.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/22/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation

struct RecipeSection: Equatable {
    let title: String
    let recipes: [Recipe]
}

func ==(lhs: RecipeSection, rhs: RecipeSection) -> Bool {
    return lhs.title == rhs.title
        && lhs.recipes == rhs.recipes
}
