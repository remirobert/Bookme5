//
//  BookCalendarViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 23/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import FSCalendar
import Hakuba

class BookCalendarViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var hakuba: Hakuba!
    private var selectedDate: NSDate?
    
    let viewModel = BookCalendarViewModel()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var indicatorNetwork: UIActivityIndicatorView!
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc func book() {
        self.performSegueWithIdentifier("bookSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.delegate = self
        
        self.calendar.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.tableview.tableFooterView = UIView()
        self.tableview.separatorStyle = .None
        
        self.hakuba = Hakuba(tableView: self.tableview)
        self.hakuba.registerCellByNib(BookSlotTableViewCell)
        self.hakuba.append(Section())
        
        self.hakuba[0].append(self.viewModel.slots.value)
        
        self.tableview.hidden = true
        self.indicatorNetwork.startAnimating()
        self.viewModel.getSlotsDate(NSDate())
        
        self.viewModel.slots.asObservable().subscribeNext { (slots: [BookSlotViewModel]) in
            self.indicatorNetwork.stopAnimating()
            self.tableview.hidden = false
            self.hakuba[0].reset()
            self.hakuba[0].append(slots)
            
            for slot in slots {
                slot.selectionHandler = { _ in
                    if slot.booked {
                        self.selectedDate = nil
                        slot.booked = false
                        self.tableview.reloadData()
                        self.navigationItem.rightBarButtonItem = nil
                        return
                    }
                    for model in slots {
                        model.booked = false
                    }
                    self.selectedDate = slot.date
                    slot.booked = true
                    self.tableview.reloadData()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Book", style: .Done, target: self, action: #selector(BookCalendarViewController.book))
                }
            }
            self.tableview.reloadData()
            }.addDisposableTo(self.disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "bookSegue" {
            let controller = segue.destinationViewController as! DetailBookViewController
            guard let date = self.selectedDate else {
                return
            }
            controller.viewModel.service = self.viewModel.service
            controller.viewModel.buisiness = self.viewModel.buisiness
            controller.viewModel.date = date
        }
    }
}

extension BookCalendarViewController: FSCalendarDelegate {
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return NSDate()
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        self.tableview.hidden = true
        self.indicatorNetwork.startAnimating()
        self.viewModel.getSlotsDate(date)
    }
}
