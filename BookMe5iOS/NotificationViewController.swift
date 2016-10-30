//
//  NotificationViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 13/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import RxSwift

class NotificationViewController: UIViewController {
    
    private let viewmodel = NotificationViewModel()
    private let disposeBag = DisposeBag()
    private var hakuba: Hakuba!
    
    private lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red:1.00, green:0.76, blue:0.00, alpha:1.00)
        refreshControl.addTarget(self, action: #selector(NotificationViewController.fetchBookmarcks), forControlEvents: .ValueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    @objc private func fetchBookmarcks() {
        self.viewmodel.fetchBookmarks()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewmodel.fetchBookmarks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        
        self.fetchBookmarcks()
        self.tableview.hidden = true
        self.hakuba = Hakuba(tableView: self.tableview)
        self.hakuba.registerCellByNib(BookmarkListTableViewCell.self)
        self.hakuba.registerCellByNib(FeedListTableViewCell.self)
        self.tableview.addSubview(self.refreshControl)
        self.tableview.tableFooterView = UIView()
        self.hakuba.append(Section())
        
        self.viewmodel.business.asObservable().subscribeNext { models in
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            
            for model in models {
                model.selectionHandler = { _ in
                    self.performSegueWithIdentifier("detailBuisinessSegue", sender: model.buisiness)
                }
            }
            
            self.tableview.hidden = false
            self.hakuba[0].reset()
            self.hakuba[0].append(models)
            self.tableview.reloadData()
            }.addDisposableTo(self.disposeBag)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailBuisinessSegue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailBuisinessViewController
            controller.detailBuisinessViewModel.buisiness = sender as? Buisiness
        }
    }
}