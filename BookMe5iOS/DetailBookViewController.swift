//
//  DetailBookViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 24/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Hakuba
import PopupDialog

class DetailBookViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var hakuba: Hakuba!
    var isReservation = false
    let viewModel = DetailBookViewModel()
    
    @IBOutlet weak var tableview: UITableView!
    
    private func dissmissBook(success: Bool) {
        let message = success ? "Le service a ete reserve" : "Erreur lors de la reservation"
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (_) in
            
            if success {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func book(sender: AnyObject) {
        self.viewModel.bookService()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if !self.isReservation {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            super.viewWillAppear(animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.hakuba = Hakuba(tableView: self.tableview)
        self.tableview.tableFooterView = UIView()
        
        self.hakuba.append(Section())
        self.hakuba.registerHeaderFooterByNib(HeaderDetailBookingView)
        self.hakuba.registerCellByNib(DetailLocationTableViewCell)
        self.hakuba.registerCellByNib(DetailBookingDetailTableViewCell)
        self.hakuba.registerCellByNib(DetailBookingImageTableViewCell)
        
        if !self.isReservation {
            guard let buisiness = self.viewModel.buisiness else {
                return
            }
            self.hakuba[0].header = HeaderDetailBookingViewModel(title: buisiness.name)
            if let service = self.viewModel.service {
                if let image = service.image {
                    self.hakuba[0].append(DetailBookingImageModel(image: image))
                }
                self.hakuba[0].append(DetailBookingDetailViewModel(service: service, date: self.viewModel.date!))
            }
            if let location = buisiness.location {
                let model = DetailLocationCellViewModel()
                model.location = location
                self.hakuba[0].append(model)
            }
        }
        else {
            guard let service = self.viewModel.service else {
                return
            }
            if let image = service.image {
                self.hakuba[0].append(DetailBookingImageModel(image: image))
            }
            if let date = service.date {
                self.hakuba[0].append(DetailBookingDetailViewModel(service: service, date: date))
            }
        }
    }
}

extension DetailBookViewController: DetailBookViewModelDelegate {
    
    func didGetErrorBooking() {
        let title = "Erreur réservation"
        let message = "Impossible de reserver ce service pour cette horaire"
        
        let popup = PopupDialog(title: title, message: message, image: nil)
        let button = CancelButton(title: "ANNULER") {
            
        }
        button.titleColor = UIColor(red:0.90, green:0.19, blue:0.16, alpha:1.00)
        popup.addButtons([button])
        self.presentViewController(popup, animated: true, completion: nil)
    }
    
    func didGetSuccessBooking() {
        let title = "Réservation effectuée"
        let message = "Vous avez reserver votre service avec succéé, vous pouvez retrouver vos réservations dans votre espace perso"
        
        let popup = PopupDialog(title: title, message: message, image: nil)
        let button = CancelButton(title: "Ok") {
            let controller = Storyboards.Main.instantiateMainController()
            UIApplication.sharedApplication().keyWindow?.rootViewController = controller
        }
        button.titleColor = UIColor(red:0.27, green:0.98, blue:0.45, alpha:1.00)
        popup.addButtons([button])
        self.presentViewController(popup, animated: true, completion: nil)
    }
}
