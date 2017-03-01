//
//  HorizontalFlowLayout.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/28/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

class HorizontalFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        scrollDirection = .horizontal
        minimumInteritemSpacing = 8
        sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        super.prepare()
    }
    
}
