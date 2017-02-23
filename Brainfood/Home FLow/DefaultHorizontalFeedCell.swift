    //
//  DefaultHorizontalFeedCell.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/6/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit
import Nuke

class DefaultHorizontalFeedCell: FeedCell {
    @IBOutlet var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func configure(withFeedItem item: FeedItem) {
        if let imageURL = item.imageUrl {
            Nuke.loadImage(with: imageURL, into: imageView)
        }
        
        titleLabel.text = item.titleString
        subtitleLabel.attributedText = item.subtitleString
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
}
