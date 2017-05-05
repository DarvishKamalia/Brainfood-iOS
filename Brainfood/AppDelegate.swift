//
//  AppDelegate.swift
//  Brainfood
//
//  Created by Darvish Kamalia on 11/1/16.
//  Copyright © 2016 Darvish Kamalia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Heap.setAppId("2180352270");
        #if DEBUG
            Heap.enableVisualizer();
        #endif

        (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
        return true
    }

}

