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

struct APIClient {
    
    private let baseUrl = URL(string: "https://pbiprrk71j.execute-api.us-west-2.amazonaws.com/prod/purchase_function")
    
//    func request() -> Promise<[ListItem]> {
//        guard let baseUrl = baseUrl else {
//            return Promise(error: InvalidURLError.invalidURL)
//        }
//    
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//        return Promise { fulfill, reject in
//            Alamofire.request(baseUrl, method: .get).responseJSON { response in
//                switch response.result {
//                case .success(let data):
//                    let json = JSON(data)
//                    let items = json.array?.flatMap { ListItem(json: $0) }
//                    
//                    if let items = items {
//                        fulfill(items)
//                    } else {
//                        reject(InvalidJSONError.inputDataNil)
//                    }
//                case .failure(let error):
//                    reject(error)
//                }
//            }
//        }.always {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//    }
    
    ///
    /// Send a request to the backend to add the item to the user's purchasing history
    /// parameter item The item to add
    /// return An array of strings, that contains the possible variations of the item, if any
    ///
    func addFoodItem(item: String) -> Promise<[String]> {
        guard let baseUrl = baseUrl else {
            return Promise(error: InvalidURLError.invalidURL)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = ["Item" : item, "User" : "darvishAB" ]//UIDevice.current.identifierForVendor?.uuidString ?? ""]

        return Promise { fulfill, reject in
            Alamofire.request(baseUrl, method: .post, parameters: parameters, encoding: URLEncoding.queryString).response { response in
                if let error = response.error {
                    reject(error)
                } else {
                    if let data = response.data,
                        let variations = JSON(data).array?.flatMap({ $0.string }) {
                        fulfill(variations)
                    }
                    else {
                        fulfill([])
                    }
                }
            }
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
