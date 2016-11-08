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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func configure(withFeedItem item: FeedItem) {
        if let imageURL = item.imageURL {
            imageView.sd_setImage(with: imageURL, placeholderImage: Utilities.defaultPlaceholderImage)
        }
        
        titleLabel.text = item.titleString
        subtitleLabel.text = item.subtitleString        
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
}
