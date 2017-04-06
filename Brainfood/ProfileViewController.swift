//
//  ProfileViewController.swift
//  Brainfood
//
//  Created by Darvish on 4/4/17.
//  Copyright © 2017 Darvish Kamalia. All rights reserved.
//

import UIKit
import IGListKit

fileprivate struct Constants {
    static let cellIdentifier = "profileCell"
}

class ProfileViewController: UIViewController, IGListAdapterDataSource, IGListAdapterDelegate {
	lazy var client: APIClient = {
		return APIClient()
	}()
    
	@IBOutlet weak var preferredStoreButton: UIButton!

	@IBOutlet weak var collectionView: IGListCollectionView!

	lazy var adapter: IGListAdapter = {
		return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
	}()

	lazy var loadingView: LoadingView = {
		return LoadingView(text: "Fetching saved recipes")
	}()

	var dataSource = [IGListDiffable]()

	// MARK: - ViewController lifecycle 

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSavedRecipes()
	}

	override func viewWillAppear(_ animated: Bool) {
		self.adapter.performUpdates(animated: true, completion: nil)
	}

	// MARK: - Actions

	@IBAction func preferredStoreButtonTapped(_ sender: Any) {
		let alert = UIAlertController(title: "Enter ZIP Code", message: "Enter your zip code to search for stores", preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.placeholder = "ZIP Code"
		}
		alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
			guard let zip = alert.textFields?.first?.text else { return }
			self.search(withZip: zip)
			alert.dismiss(animated: true, completion: nil)
		}))
		present(alert, animated: true, completion: nil)
	}

	// MARK: - Helpers 

	private func search(withZip zip: String) {
		client.fetchRecommendedStores(forText: zip)
			.then { results -> Void in
				let resultList = StoresListTableViewController(style: .grouped)
					resultList.stores = results
					resultList.profileVC = self
					self.show(resultList, sender: nil)
			}
			.catch { error in
				print (error)
		}
	}

	func user(didSelect store: String) {
		preferredStoreButton.setTitle(store, for: .normal)
		navigationController?.popViewController(animated: true)
	}

	private func setupSavedRecipes() {

		

		adapter.collectionView = collectionView
		adapter.dataSource = self
		adapter.delegate = self
	}

	// MARK: - IGListAdapterDataSource

	func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
		return dataSource
	}

	func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
		return RecipeSectionController()
	}

	func emptyView(for listAdapter: IGListAdapter) -> UIView? {
		return loadingView
	}

	func listAdapter(_ listAdapter: IGListAdapter!, willDisplay object: Any!, at index: Int) {

	}

	func listAdapter(_ listAdapter: IGListAdapter!, didEndDisplaying object: Any!, at index: Int) {

	}
}
