//
//  UserStore.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 4/5/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserStore {
    
    static let shared = UserStore()
    
    private let bookmarksFileName = "bookmarks.json"
    var bookmarks = Set<String>()
    
    init() {
        fetchBookmarks()
    }
    
    private func fetchBookmarks() {
        guard
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(bookmarksFileName),
            let data = try? Data(contentsOf: url),
            let json = JSON(data: data).array
        else { return }
        
        bookmarks.removeAll()
        
        let recipeIdentifiers = json.flatMap { $0.string }
        recipeIdentifiers.forEach { bookmarks.insert($0) }
    }
    
    func addBookmark(for recipe: Recipe) {
        bookmarks.insert(recipe.name)
    }
    
    func checkBookmark(for recipe: Recipe) -> Bool {
        return bookmarks.contains(recipe.name)
    }
    
    private func saveBookmarks() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(bookmarksFileName) else { return }
        
        let json = JSON(bookmarks)
        do {
            try json.rawData().write(to: url)
        } catch let error {
            print(error)
        }
    }
    
}
