import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

extension APIClient {
    func fetchRecommendedStores(forText searchText: String) -> Promise<[String]> {
        guard let url = URL(string: Constants.baseURL + Constants.storeSearchEndpoint) else {
            return Promise(error: InvalidURLError.invalidURL)
        }
        
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .get, parameters: ["zipCode" : searchText], encoding: URLEncoding.queryString).response { response in
                if
                    let responseData = response.data,
                    let responseJSON = JSON(data: responseData).array
                {
                    let results = responseJSON.flatMap() { $0.string }
                    fulfill(results)
                }
                else {
                    reject(InvalidJSONError.inputDataNil)
                }
            }
        }
    }
}
