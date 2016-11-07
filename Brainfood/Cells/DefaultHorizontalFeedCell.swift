//
//  HorizontalFeedCell.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/4/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class DefaultHorizontalFeedCell: FeedCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure (withFeedItem item: FeedItem) {
        if let imageURL = item.imageURL {
            do {
             try imageView.image = UIImage(data: Data(contentsOf: imageURL))
            }
            
            catch {
                assertionFailure("Could not load image from URL")
            }
        }
        
        for labelText in item.descriptors {
            let label = UILabel()
            label.text = labelText
            stackView.addArrangedSubview(label)
        }
    }
}
