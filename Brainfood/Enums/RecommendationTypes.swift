//
//  RecommendationTypes.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

enum RecommendationType {
    case ShoppingList
    case Recipes
    case PurchaseHistory
    case Deals
    case CartPrice
    
    var fetchEndpoint: String  {
        switch (self) {
            case .PurchaseHistory: return "getPurchaseHistoryRecommendations"
            case .Recipes: return  "getRecommendedRecipes"
            case .ShoppingList: return ""
            case .Deals: return "getDeals"
            case .CartPrice: return "getCartPrices"
        }
    }
}

