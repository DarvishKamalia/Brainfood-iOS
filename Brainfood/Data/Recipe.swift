//
//  Recipe.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/29/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit
import IGListKit
import RealmSwift

// Required to store ingredients in Realm database
class RealmString: Object {
    dynamic var stringValue = ""
}

final class Recipe: Object, FeedItem, IGListDiffable {
    dynamic var name: String = ""
    dynamic var imageUrl: String = ""
    dynamic var linkUrl: String = ""
    var persistentIngredients = List<RealmString>()

    var ingredients: [String] {
        get {
            return persistentIngredients.map() { $0.stringValue }
        }
        set {
            persistentIngredients.removeAll()
            let realmStrings = newValue.map() { RealmString(value: [$0]) }
            persistentIngredients.append(contentsOf: realmStrings)
        }
    }

    override static func ignoredProperties() -> [String] {
        return ["ingredients"]
    }
    
    convenience init (name: String, imageUrl: String = "", linkUrl: String = "", ingredients: [String] = []) {
        self.init()
        self.name = name
        self.imageUrl = imageUrl
        self.linkUrl = linkUrl
        self.ingredients = ingredients
    }
    
    convenience init?(from json: JSON) {
        self.init()
        guard let name = json["title"].string else { return nil }
        
        self.name = name
        
        let id = json["id"].number?.int64Value
        imageUrl = "http://d27bfab0aa6b39479cb3-cb8f43ffb46322cff58594e95a13ac65.r29.cf5.rackcdn.com/\(id ?? 0).jpg"
        linkUrl = json["url"].string ?? ""
        
        let used = json["uses"].array?.flatMap { $0.string } ?? []
        let remaining = json["needs"].array?.flatMap { $0.string } ?? []
        ingredients = used + remaining
    }

    // MARK: - FeedItem variables
    
    var titleString: String {
        return name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var subtitleString : NSAttributedString {
        return NSAttributedString(string: "")
    }
    
    // MARK: - Hashable
    
    override var hashValue: Int {
        return name.hashValue
    }

    // MARK: - Realm 

    override class func primaryKey() -> String {
        return "name" 
    }

    var isSaved: Bool {
        let realm = try! Realm()
        return realm.object(ofType: Recipe.self, forPrimaryKey: name) != nil 
    }
    
    // MARK: - IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return name as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return self == (object as? Recipe)
    }
}

func ==(lhs: Recipe, rhs: Recipe) -> Bool {
    return lhs.name == rhs.name
        && lhs.imageUrl == rhs.imageUrl
        && lhs.linkUrl == rhs.linkUrl
        && lhs.ingredients == rhs.ingredients
}
