//
//  DetailBuisinessViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 18/02/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import PINRemoteImage
import Hakuba
import ZFDragableModalTransition

class DetailBuisinessViewController: UIViewController {
    
    private var hakuba: Hakuba!
    private let sectionDetail = Section()
    private let sectionServices = Section()
    private let sectionComments = Section()
    private var transition: ZFModalTransitionAnimator!
    
    lazy var headerView: HeaderDetailView! = {
        let headerView = UINib(nibName: "HeaderDetailView", bundle: nil).instantiateWithOwner(self, options: nil).first as! HeaderDetailView
        headerView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 300)
        return headerView
    }()
    let detailBuisinessViewModel = DetailBuisinessViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.hakuba.deselectAllCells(animated: true)
        self.detailBuisinessViewModel.postStatsVisit()
    }
    
    @objc func bookmark() {
        self.detailBuisinessViewModel.bookmark()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.buttonClose.rx_tap.subscribeNext {
            self.dismissViewControllerAnimated(true, completion: nil)
            }.addDisposableTo(self.disposeBag)
        
        self.hakuba = Hakuba(tableView: self.tableView)
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        //        self.tableView.separatorStyle = .None
        //        self.tableView.tableFooterView = UIView()
        
        self.hakuba.registerHeaderFooterByNib(HeaderDetailBuisinessTableViewCell)
        self.hakuba.registerHeaderFooterByNib(HeaderServicesTableViewCell)
        self.hakuba.registerCellByNib(DetailLocationTableViewCell)
        self.hakuba.registerCellByNib(DescriptionTableViewCell)
        self.hakuba.registerCellByNib(PictureDetailTableViewCell)
        self.hakuba.registerCellByNib(CommentCellTableViewCell)
        self.hakuba.registerCellByNib(ServiceTableViewCell)
        
        self.hakuba.append(self.sectionDetail)
        self.hakuba.append(self.sectionServices)
        self.hakuba.append(self.sectionComments)
        
        self.title = self.detailBuisinessViewModel.buisiness?.name
        self.sectionServices.header = HeaderServicesViewModel(title: "Services")
        self.sectionComments.header = HeaderServicesViewModel(title: "Commentaires")
        
        self.detailBuisinessViewModel.models.asObservable().subscribeNext { models in
            self.sectionDetail.reset()
            self.sectionDetail.append(models).bump(.Automatic)
            self.tableView.reloadData()
            }.addDisposableTo(self.disposeBag)
        
        self.detailBuisinessViewModel.services.asObservable().subscribeNext { models in
            self.sectionServices.append(models).bump(.Automatic)
            for model in models {
                model.selectionHandler = { _ in
                    self.performSegueWithIdentifier("detailService", sender: model.service)
                }
            }
            self.tableView.reloadData()
            }.addDisposableTo(self.disposeBag)
        

        self.detailBuisinessViewModel.comments.asObservable().subscribeNext { comments in
            let models = comments.map({ comment -> CommentCellModel in
                return CommentCellModel(comment: comment)
            })
            self.sectionComments.reset()
            self.sectionComments.append(models)
            self.tableView.reloadData()
        }.addDisposableTo(self.disposeBag)
        
        self.detailBuisinessViewModel.book.asObservable().subscribeNext { booked in
            guard let booked = booked else {
                return
            }
            if booked {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark-off"), style: .Done, target: self, action: #selector(DetailBuisinessViewController.bookmark))
            }
            else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark-on"), style: .Done, target: self, action: #selector(DetailBuisinessViewController.bookmark))
            }
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:1.00, green:0.68, blue:0.01, alpha:1.00)
            }.addDisposableTo(self.disposeBag)
        
        self.detailBuisinessViewModel.initModels()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailService" {
            guard let buisiness = self.detailBuisinessViewModel.buisiness else {
                return
            }
            let controller = segue.destinationViewController as! DetailServiceViewController
            
            controller.viewModel = DetailServiceViewModel(service: sender as! Service, buisiness: buisiness)
            
            self.transition = ZFModalTransitionAnimator(modalViewController: controller)
            self.transition.dragable = false
            self.transition.direction = .Bottom
            self.transition.behindViewScale = 1
            self.transition.behindViewAlpha = 0.7
            controller.transitioningDelegate = self.transition
        }
    }
}
