//
//  ViewController.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.blue
        
        TestRecommendationDataSource.fetchRecommendations(type: .PurchaseHistory) {
            products in
            
            let vc = HorizontalFeedVC(items: products, title: "PurchaseHistory")
            
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
            self.scrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

