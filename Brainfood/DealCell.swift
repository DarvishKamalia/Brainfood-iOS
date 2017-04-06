//
//  DealCell.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 4/5/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import Nuke

class DealCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel?.text = nil
        descriptionLabel?.text = nil
    }
    
    func configure(for product: Product) {
        if let imageUrl = product.imageUrl {
            Nuke.loadImage(with: imageUrl, into: imageView)
        } else {
            // placeholder image
        }
        
        titleLabel?.text = product.titleString
        descriptionLabel?.attributedText = product.subtitleString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
}
