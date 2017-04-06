//
//  APIClient.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 1/29/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import PromiseKit

class APIClient {
    
    static let shared = APIClient()
    
    internal struct Constants {
        static let baseURL = "https://pbiprrk71j.execute-api.us-west-2.amazonaws.com/prod/"
        static let purchaseFunctionEndpoint = "purchase_function"
        static let userID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        static let storeSearchEndpoint = "searchStores/"
    }
    
    func fetchRecommendations(type: RecommendationType, forItems items: [String]? = nil) -> Promise<[FeedItem]>  {
        guard let url = URL(string: Constants.baseURL + type.fetchEndpoint) else {
            return Promise(error: InvalidURLError.invalidURL)
        }		
        
        
        var parameters = ["User": Constants.userID]

        var productNames = "\"Milk\",\"eggs\""
        
        if let items = items, items.count > 0 {
            productNames = items.joined(separator: ",")
        }

        parameters["items"] = productNames

        return Promise { fulfill, reject in
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString).response { response in
                if let error = response.error {
                    reject(error)
                    return
                }
                
                if let responseData = response.data, let responseJSON = JSON(data: responseData).array  {
                    switch type {
                        case .PurchaseHistory, .Deals:
                            let products = responseJSON.flatMap() { Product(from: $0) }
                            fulfill(products)
                        case .Recipes:
                            let recipes = responseJSON.flatMap() { Recipe(from: $0)}
                            fulfill(recipes)
                        case .ShoppingList:
                            fulfill([])
                        case .CartPrice:
                            fulfill( responseJSON.flatMap() { CartPrice(fromJSON: $0) })
                    }
                }
            }
        }
    }
    
    // MARK: - Edit Shopping Cart
    
    /// Send a request to the backend to add the item to the user's purchasing history
    /// parameter item The item to add
    /// return An array of strings, that contains the possible variations of the item, if any
    func addFoodItem(item: String) -> Promise<[String]> {
        guard let url = URL(string: Constants.baseURL + Constants.purchaseFunctionEndpoint) else {
            return Promise(error: InvalidURLError.invalidURL)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = ["Item": item, "User": Constants.userID]
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString).response { response in
                if let error = response.error {
                    reject(error)
                } else {
                    if
                        let data = response.data,
                        let variations = JSON(data).array?.flatMap({ $0.string })
                    {
                        fulfill(variations)
                    } else {
                        ShoppingCart.shared.add(item: item)
                        fulfill([])
                    }
                }
            }
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
