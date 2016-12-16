//
//  FeedListViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 27/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Hakuba
import ZFDragableModalTransition

class FeedListViewController: UIViewController {
    
    private var hakuba: Hakuba!
    private let feedListViewModel = FeedListViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red:1.00, green:0.76, blue:0.00, alpha:1.00)
        refreshControl.addTarget(self, action: #selector(FeedListViewController.fetchList), forControlEvents: .ValueChanged)
        return refreshControl
    }()
    
    private lazy var mapView: MapViewServices! = UINib(nibName: "MapViewServices", bundle: nil).instantiateWithOwner(self, options: nil).first as! MapViewServices

    @IBOutlet weak var tableView: UITableView!
    
    @objc private func fetchList() {
        self.feedListViewModel.fetchFeedList()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame.size.height = 250
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }

    override func viewWillAppear(animated: Bool) {
        mapView.frame.size.height = 250
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hakuba = Hakuba(tableView: self.tableView)
        self.hakuba.registerCellByNib(FeedListTableViewCell)
        self.hakuba.append(Section())
        
//        self.mapView.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(self.view)
//        }
//        self.mapView.hidden = true

//        self.segmentController.rx_value.subscribeNext { index in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.mapView.hidden = index == 0
//                self.tableView.hidden = index == 1
//            })
//            }.addDisposableTo(self.disposeBag)

        self.view.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)

        mapView.clipsToBounds = true
        mapView.frame.size.height = 250
        self.tableView.tableHeaderView = mapView
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        
        self.feedListViewModel.buisiness.asObservable().subscribeNext { models in
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            
            for model in models {
                model.selectionHandler = { _ in
                    self.performSegueWithIdentifier(FeedListViewController.Segue.detailBuisinessSegue.identifier!, sender: model.buisiness)
                }
            }
            
            self.mapView.configure(models.map({ $0.buisiness }))

            self.hakuba[0].reset()
            self.hakuba[0].append(models)
            self.tableView.reloadData()
            }.addDisposableTo(self.disposeBag)
        
        self.feedListViewModel.fetchFeedList()
        
        self.tableView.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == FeedListViewController.Segue.detailBuisinessSegue.identifier {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailBuisinessViewController
            controller.detailBuisinessViewModel.buisiness = sender as? Buisiness
        }
    }
}
