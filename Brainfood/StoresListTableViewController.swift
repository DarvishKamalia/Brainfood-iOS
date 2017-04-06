//
//  StoresListTableViewController.swift
//  Brainfood
//
//  Created by Darvish on 4/5/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

class StoresListTableViewController: UITableViewController {

    var stores: [String] = []
    var profileVC: ProfileViewController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stores.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "storeCell")

        cell.textLabel?.text = stores[indexPath.row]
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileVC.user(didSelect: stores[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
