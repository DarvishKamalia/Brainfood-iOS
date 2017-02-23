//
//  FeedItem.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/2/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation

protocol FeedItem {
    
    var imageUrl: URL? { get }
    var titleString: String { get }
    var subtitleString: String { get }
    
}
