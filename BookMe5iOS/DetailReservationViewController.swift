//
//  DetailReservationViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 23/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import RxSwift
import SwiftMoment

class DetailReservationViewController: UIViewController {
    
    var reservation: Reservation?
    
    private let disposeBag = DisposeBag()
    private var hakuba: Hakuba!
    private let viewModel = DetailReservationViewModel()
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func comment(sender: AnyObject) {
        self.performSegueWithIdentifier("commentSegue", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let endDate = self.reservation?.start else {
         	   return
        }
        if moment(endDate) < moment() {
            self.commentView.hidden = false
            self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentView.hidden = true
        
        self.hakuba = Hakuba(tableView: self.tableview)
        self.tableview.tableFooterView = UIView()
        self.tableview.separatorStyle = .None
        self.hakuba.registerCellByNib(DetailBookingImageTableViewCell)
        self.hakuba.registerCellByNib(DetailBookingDetailTableViewCell)
        self.hakuba.registerCellByNib(DetailLocationTableViewCell)
        self.hakuba.append(Section())
        
        guard let reservation = self.reservation else {
            return
        }
        
        self.title = reservation.business?.name
        
        self.viewModel.models.asObservable().subscribeNext { models in
            self.hakuba[0].reset()
            self.hakuba[0].append(models)
            self.tableview.reloadData()
            }.addDisposableTo(self.disposeBag)
        self.viewModel.bindUi(reservation)
    }
}
