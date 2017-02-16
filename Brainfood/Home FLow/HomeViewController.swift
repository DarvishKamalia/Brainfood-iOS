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
    
    let client = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        let _ = client.fetchRecommendations(type: .PurchaseHistory).then { items -> Void in
            let vc = HorizontalFeedVC(items: items, title: "Based on your shopping list")
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 200)
            self.scrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
        
        let _ = client.fetchRecommendations(type: .Recipes).then { recipes -> Void in
            let vc = HorizontalFeedVC(items: recipes, title: "Recipes that use items in your list")
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 220, width: self.view.frame.width, height: 200)
            self.scrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

