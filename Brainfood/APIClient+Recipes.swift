//
//  APIClient+Recipes.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/18/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

extension APIClient {
    
    var recipesEndpoint: String {
        return "getRecipes"
    }
    
    func getRecipes(forItems items: [Product], index: Int = 0) -> Promise<[Recipe]> {
        guard let url = URL(string: Constants.baseURL + recipesEndpoint) else {
            return Promise(error: InvalidURLError.invalidURL)
        }
        
        let productNames = items.map { $0.name }.joined(separator: ",")
        let parameters = ["items": productNames, "index": "\(index)"]
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
                
                let recipes = json.flatMap() { Recipe(from: $0)}
                fulfill(recipes)
            }
        }
    }
    
}
