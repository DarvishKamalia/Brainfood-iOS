//
//  ViewController.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var items : [Product] = []
        
        items.append(Product(name: "Test Product 1", imageURL: "http://www.americanyp.com/users_content/users_images/logos/groceries.jpg"))
        
        let vc = HorizontalFeedVC(items: items)
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

