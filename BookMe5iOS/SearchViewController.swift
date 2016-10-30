//
//  SearchViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 12/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Hakuba
import ZFDragableModalTransition

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    private var isSearching = false
    private var transition: ZFModalTransitionAnimator!
    private var hakuba: Hakuba!
    
    private let categories = [
        SearchCategoriesViewModel(category: "Restaurant"),
        SearchCategoriesViewModel(category: "Hôtel"),
        SearchCategoriesViewModel(category: "Salon de coiffure")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.hakuba.deselectAllCells(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "SearchCategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "cat")
        self.tableView.registerNib(UINib(nibName: "FeedListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.hakuba = Hakuba(tableView: self.tableView)
        self.hakuba.registerCellByNib(SearchCategoriesTableViewCell)
        self.hakuba.registerCellByNib(SearchResultTableViewCell)
        self.hakuba.append(Section())
        
        self.viewModel.searchResult.asObservable().subscribeNext { models in
            for model in models {
                model.selectionHandler = { _ in
                    self.performSegueWithIdentifier("detailBuisinessSegue", sender: model.buisiness)
                }
            }
            self.hakuba[0].reset()
            self.hakuba[0].append(models)
            self.tableView.reloadData()
            }.addDisposableTo(self.disposeBag)
        
        for category in categories {
            category.selectionHandler = { _ in
                let input = category.category
                self.searchBar.text = input
                self.viewModel.search(input)
            }
        }
        self.hakuba[0].append(self.categories)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailBuisinessSegue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailBuisinessViewController
            controller.detailBuisinessViewModel.buisiness = sender as? Buisiness
            
            self.transition = ZFModalTransitionAnimator(modalViewController: controller)
            self.transition.dragable = true
            self.transition.direction = ZFModalTransitonDirection.Right
            
            controller.transitioningDelegate = self.transition
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.isSearching = false
        self.searchBar.text = ""
        self.view.endEditing(true)
        
        self.hakuba[0].reset()
        self.hakuba[0].append(self.categories)
        self.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
            return false
        }
        self.isSearching = true
        let input = "\(self.searchBar.text!)\(text)"
        self.viewModel.search(input)
        return true
    }
}
