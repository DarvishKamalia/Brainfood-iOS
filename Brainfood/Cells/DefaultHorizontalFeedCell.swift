//
//  DefaultHorizontalFeedCell.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/6/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class DefaultHorizontalFeedCell: FeedCell {
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func configure(withFeedItem item: FeedItem) {
        if let imageURL = item.imageURL {
            imageView.sd_setImage(with: imageURL, placeholderImage: Utilities.defaultPlaceholderImage)

        }
        
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
}
