//
//  ShoppingCartViewController.swift
//  Brainfood
//
//  Created by Ayush Saraswat on 2/22/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import IGListKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartPricesContainerView: UIView!

    var cartPricesCollectionViewController = HorizontalCollectionViewController()
    
    lazy var apiClient: APIClient = {
        return APIClient()
    }()
    
    var items = Array(repeating: CartPrice(storeName: "Kroger", imageUrl: URL(string: "https://images.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.martinbands.com%2Fimages%2Fkroger.svg&f=1"), totalPrice: 10.0), count: 5)
    
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
        
        cartPricesContainerView.addSubview(cartPricesCollectionViewController.view)
        addChildViewController(cartPricesCollectionViewController)
        cartPricesCollectionViewController.didMove(toParentViewController: self)
        cartPricesCollectionViewController.view.frame = cartPricesContainerView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPrices()
    }
    
    func updateViewState() {
        switch viewState {
        case .ready:
            emptyView.isHidden = true
            tableView.isHidden = false
            cartPricesContainerView.isHidden = false
        case .editing:
            emptyView.isHidden = true
            tableView.isHidden = false
            cartPricesContainerView.isHidden = false
        case .empty:
            emptyView.isHidden = false
            tableView.isHidden = true
            cartPricesContainerView.isHidden = true
        default:
            break
        }
    }
    
    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ShoppingCart.shared.cartItems.count
        if count == 0 {
            viewState = .empty
        } else if count != 0 && (viewState != .ready || viewState != .editing) {
            viewState = .ready
        }
        return count
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
                self?.add(item: itemDescription)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addTextField { textField in
            textField.placeholder = "pineapple"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func add(item: String) {
        let _ = apiClient.addFoodItem(item: item)
            .then { [weak self] variations -> Void in
                self?.handleVariations(variations, ofItem: item)
            }
            .always(on: DispatchQueue.main) { [weak self] in
                self?.tableView.reloadData()
                self?.loadPrices()
            }
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
    
    @IBAction func clickOnRecommendation(button: UIButton) {
        guard let item = button.titleLabel?.text else { return }
        add(item: item)
        
        tableView.reloadData()
    }
    
    // MARK: - API Calls
    
    func loadPrices() {
        cartPricesCollectionViewController.items = []
        apiClient
            .fetchRecommendations(type: .CartPrice, forItems: ShoppingCart.shared.cartItems)
            .then { items -> Void in
                let items = items.flatMap { $0 as? CartPrice }
                self.cartPricesCollectionViewController.items = items
            }
            .catch { error in
                print(error)
            }
    }

}
