//
//  ShoppingCart.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/22/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import Foundation

class ShoppingCart {
    
    // MARK: - Singleton
    
    static let shared = ShoppingCart()
    
    // MARK: -
    
    private let defaultsKey = "com.brainfood.shoppingCart"
    private var items: [String] {
        didSet {
            guard items != oldValue else { return }
            save()
        }
    }
    
    private var selectionStates: [String: Bool]
    
    // MARK: - Initializers
    
    init() {
        items = UserDefaults.standard.array(forKey: defaultsKey) as? [String] ?? []
        selectionStates = items.reduce([:]) { dictionary, item in
            var dictionary = dictionary
            dictionary[item] = false
            return dictionary
        }
    }
    
    // MARK: - Access Modifiers
    
    var cartItems: [String] {
        return items
    }
    
    // MARK: - Modify Cart
    
    func add(item: String) {
        items.append(item)
        selectionStates[item] = false
    }
    
    func remove(item: String) {
        guard let index = items.index(of: item) else { return }
        items.remove(at: index)
        selectionStates.removeValue(forKey: item)
    }
    
    func remove(at index: Int) {
        guard index >= 0 && index < items.count else { return }
        selectionStates.removeValue(forKey: items[index])
        items.remove(at: index)
    }
    
    func clear() {
        items.removeAll(keepingCapacity: false)
        selectionStates.removeAll()
    }
    
    // MARK: - Selection States
    
    func numberOfSelections() -> Int {
        return selectionStates.filter { $0.value == true }.count
    }
    
    func selectItem(at index: Int) {
        guard index >= 0 && index < items.count else { return }
        selectionStates[items[index]] = !(selectionStates[items[index]] ?? false)
    }
    
    func selectionState(for item: String) -> Bool {
        return selectionStates[item] ?? false
    }
    
    func clearSelectionStates() {
        items.forEach {
            selectionStates[$0] = false
        }
    }
    
    // MARK: - Save
    
    func save() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShoppingCartUpdate"), object: nil)
        UserDefaults.standard.set(items, forKey: defaultsKey)
    }
    
}
