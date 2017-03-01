//
//  LoadingView.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/27/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

final class LoadingView: UIView {

    private let loadingIndicator: UIActivityIndicatorView
    private let loadingPrompt: UILabel
    
    private let stackView: UIStackView
    private let text: String
    
    init(text: String) {
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingPrompt = UILabel(frame: .zero)
        stackView = UIStackView(arrangedSubviews: [loadingIndicator, loadingPrompt])
        self.text = text
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        loadingIndicator.color = .black
        loadingIndicator.startAnimating()
        
        loadingPrompt.text = text
        loadingPrompt.textColor = .black
        loadingPrompt.font = UIFont(name: "Futura", size: 14.0)
        loadingPrompt.numberOfLines = 0
        loadingPrompt.textAlignment = .center
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
    
        addSubview(stackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.center = center
    }
    
}
