//
//  ShoppingCartViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/22/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var purchasedButton: UIButton!

    lazy var apiClient: APIClient = {
        return APIClient()
    }()
    
    var viewState: ViewState = .ready {
        didSet {
            guard viewState != oldValue else { return }
            updateViewState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "ShoppingCartUpdate"), object: self, queue: OperationQueue.main) { _ in
            self.tableView.reloadData()
        }
    }
    
    func updateViewState() {
        switch viewState {
        case .ready:
            tableView.isHidden = false
            purchasedButton.isHidden = true
        case .editing:
            tableView.isHidden = false
            purchasedButton.isHidden = false
        default:
            break
        }
    }
    
    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCart.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath)
        
        let item = ShoppingCart.shared.cartItems[indexPath.row]
        cell.textLabel?.text = item
        cell.accessoryType = ShoppingCart.shared.selectionState(for: item) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShoppingCart.shared.selectItem(at: indexPath.row)
        viewState = ShoppingCart.shared.numberOfSelections() == 0 ? .ready : .editing
        
        tableView.reloadData()
    }
    
    // MARK: - Table View Editing
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            ShoppingCart.shared.remove(at: indexPath.row)
            tableView.reloadData()
        default: break
        }
    }
    
    // MARK: - Add

    @IBAction func add() {
        let alertController = UIAlertController(title: "Add New Item", message: "Enter item name", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first {
                let itemDescription = textField.text ?? ""
                let _ = self?.apiClient.addFoodItem(item: itemDescription)
                    .then { [weak self] variations -> Void in
                        alertController.dismiss(animated: true, completion: nil)
                        self?.handleVariations(variations, ofItem: itemDescription)
                    }
                    .always {
                        self?.tableView.reloadData()
                    }
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addTextField { textField in
            textField.placeholder = "pineapple"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func handleVariations(_ variations: [String], ofItem item: String) {
        guard variations.count > 0 else {
            return
        }
        
        let alertController = UIAlertController(title: "Choose a variation", message: "What kind of \(item) do you usually buy?", preferredStyle: .actionSheet)
        variations.forEach { variation in
            let action = UIAlertAction(title: variation, style: .default, handler: { [weak self] _ in
                self?.apiClient.addFoodItem(item: variation + " " + item).always {
                    alertController.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Purchase
    
    @IBAction func markAsPurchased(button: UIButton) {
        ShoppingCart.shared.clearSelectionStates()
        viewState = .ready
        
        // TODO: upload purchase history to server
        
        tableView.reloadData()
    }

}
