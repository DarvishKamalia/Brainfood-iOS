//
//  RecommendationTypes.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

fileprivate let APIBaseURL = "https://pbiprrk71j.execute-api.us-west-2.amazonaws.com/prod/"

enum RecommendationType {
    case ShoppingList
    case Recipes
    case PurchaseHistory
    
    var fetchURLString : String  {
        switch (self) {
        case .PurchaseHistory: return "google.com"
        case .Recipes: return APIBaseURL + "getRecommendedRecipes?customerID=1234"
        case .ShoppingList: return ""
        }
    }
}

