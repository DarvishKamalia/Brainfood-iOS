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


func fetchRecommendations (type: RecommendationTypes, completionHandler: @escaping (([Product]) -> Void)) {
    var fetchURL: URL?
    
    switch type {
        case .PurchaseHistory: fetchURL = URL(string: Constants.productFetchURL)
        default : break
    }
    
    guard let url = fetchURL else {
        assertionFailure("Could not create valid URL to fetch recommendations")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let jsonData = data {
            do {
                let objects = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                
                if let productsJSON = (objects as? [[String : AnyObject]]) {
                    let products = productsJSON.map(){ (productJSON) in
                        return Product(fromJSON: productJSON)
                    }.flatMap {$0}
                    
                    completionHandler(products)
                }
            }
            
            catch {
                assertionFailure("Error Parsing JSON")
            }
            
        }
        
    }
    
}
