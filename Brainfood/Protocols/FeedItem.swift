//
//  FeedItem.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/2/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import Foundation
import IGListKit

protocol FeedItem: IGListDiffable {
    var imageUrl: String { get }
    var titleString: String { get }
    //Fix this to be slightly better pls 
    var subtitleString: NSAttributedString { get }
}
