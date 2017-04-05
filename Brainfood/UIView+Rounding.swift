//
//  UIView+Rounding.swift
//  Event Share
//
//  Created by Ayush Saraswat on 3/10/17.
//  Copyright © 2017 SwatTech, LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func round(corners: UIRectCorner, with cornerRadii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer
    }
    
}
