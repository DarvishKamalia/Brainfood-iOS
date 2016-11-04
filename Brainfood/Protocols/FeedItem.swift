//
//  FeedItem.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/2/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

protocol FeedItem {
    var imageURL : URL? { get }
    var descriptors : [String] { get }
}

extension FeedItem where Self : Product {
    var imageURL : URL? {
        return self.imageURL
    }
    
    var descriptors : [String] {
        return [self.name]
    }
}

