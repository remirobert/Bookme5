//
//  DetailServiceViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 08/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import PINRemoteImage
import Hakuba

class DetailServiceViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var hakuba: Hakuba!
    var viewModel: DetailServiceViewModel?
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonBook: UIButton!
    
    @IBAction func `return`(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func book(sender: AnyObject) {
        guard let service = self.viewModel?.service else {
            return
        }
        self.performSegueWithIdentifier("bookCalendarSegue", sender: service)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.tableFooterView = UIView()
        self.tableview.separatorStyle = .None
        self.hakuba = Hakuba(tableView: self.tableview)
        
        self.hakuba.registerCellByNib(ServicePictureTableViewCell)
        self.hakuba.registerCellByNib(ServiceDescriptionTableViewCell)
        self.hakuba.registerCellByNib(ServiceInfoTableViewCell)
        
        self.hakuba.append(Section())
        
        self.viewModel?.initModels()
        self.viewModel?.models.asObservable().subscribeNext({ models in
            self.hakuba[0].reset()
            self.hakuba[0].append(models)
            self.tableview.reloadData()
        }).addDisposableTo(self.disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "bookCalendarSegue" {
            let controller = segue.destinationViewController as! UINavigationController
            let bookController = controller.topViewController as! BookCalendarViewController
            bookController.viewModel.service = sender as? Service
            bookController.viewModel.buisiness = self.viewModel?.buisiness
        }
    }
}
