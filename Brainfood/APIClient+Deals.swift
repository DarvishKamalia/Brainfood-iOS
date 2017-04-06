//
//  APIClient+Deals.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 4/5/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

extension APIClient {
    
    var dealsEndpoint: String {
        return "getDeals"
    }
    
    func getDeals(for items: [String] = ShoppingCart.shared.cartItems) -> Promise<[Product]> {
        guard let url = URL(string: Constants.baseURL + dealsEndpoint) else {
            return Promise(error: InvalidURLError.invalidURL)
        }
        
        var parameters = ["User": Constants.userID]
        if !items.isEmpty {
            parameters["items"] = items.joined(separator: ",")
        }
        
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString).response { response in
                guard let data = response.data, let json = JSON(data: data).array else {
                    if let error = response.error {
                        reject(error)
                    } else {
                        reject(InvalidJSONError.inputDataNil)
                    }
                    return
                }
                
                let deals = json.flatMap { Product(from: $0) }
                fulfill(deals)
            }
        }
    }
    
}
