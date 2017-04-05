//
//  ProfileViewController.swift
//  Brainfood
//
//  Created by Darvish on 4/4/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let cellIdentifier = "profileCell"
}

class ProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var preferredStoreTextField: UITextField!
    var suggestionsTableView = UITableView(frame: .zero)
    var suggestedStores: [String] = []
    
    let client = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredStoreTextField.delegate = self
        suggestionsTableView.isHidden = true
        view.addSubview(suggestionsTableView)
        suggestionsTableView.widthAnchor.constraint(equalTo: preferredStoreTextField.widthAnchor, multiplier: 1.0)
        suggestionsTableView.heightAnchor.constraint(equalToConstant: 200.0)
        suggestionsTableView.topAnchor.constraint(equalTo: preferredStoreTextField.bottomAnchor)
        suggestionsTableView.centerXAnchor.constraint(equalTo: preferredStoreTextField.centerXAnchor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        client.fetchRecommendedStores(forText: text)
        .then { results -> Void in
            self.suggestedStores = results
            self.suggestionsTableView.isHidden = false
            self.suggestionsTableView.reloadData()
        }
        .catch { error in
            print (error)
        }
    }
    
    // MARK: - UITableView methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        preferredStoreTextField.text = suggestedStores[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        cell.textLabel?.text = suggestedStores[indexPath.row]
        return cell
    }
}
