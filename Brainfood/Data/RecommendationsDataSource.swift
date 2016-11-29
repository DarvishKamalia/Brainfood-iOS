//
//  Networking.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

fileprivate struct Constants {
    static let productFetchURL = "www.google.com"
}

class RecommendationsDataSource {

    static func fetchRecommendations (type: RecommendationType, completionHandler: @escaping (([FeedItem]) -> Void)) {
        guard let url = URL(string: type.fetchURLString) else {
            assertionFailure("Could not create valid URL to fetch recommendations")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let jsonData = data {
                do {
                    let objects = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                    
                    if let itemsJSON = (objects as? [[String : AnyObject]]) {
                        let items = itemsJSON.map() { (json) in
                            /*switch (type) {
                                case .PurchaseHistory, .ShoppingList: return Product(fromJSON: json)
                                case .Recipe: return Recipe(fromJSON: json)
                                case .ShoppingList: return nil
                            }*/
                            return type == .Recipes ? Recipe(fromJSON: json) : Product(fromJSON: json)
                        }.flatMap {$0}
                        
                        completionHandler(items)
                    }
                }
                
                catch {
                    assertionFailure("Error Parsing JSON")
                }
            }
        }
        
        task.resume()
        
    }
}
