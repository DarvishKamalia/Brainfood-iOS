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
