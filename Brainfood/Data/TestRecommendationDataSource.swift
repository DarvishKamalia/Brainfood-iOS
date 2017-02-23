//
//  TestRecommendationDataSource.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/7/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

#if DEBUG
    class TestRecommendationDataSource {
        static func fetchRecommendations (type: RecommendationType, completionHandler: @escaping (([FeedItem]) -> Void)) {
            switch type {
                case .PurchaseHistory, .Deals:
                    let item = Product(name: "Test Product", imageUrl: URL(string: "http://www.americanyp.com/users_content/users_images/logos/groceries.jpg"))
                    completionHandler(Array(repeating: item, count: 10))
                    
                case .Recipes, .ShoppingList : break
            }
        }
    }
#endif
