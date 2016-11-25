//
//  MessageViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 13/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import RxSwift

class MessageViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    private let viewmodel = GroupMessageViewModel()
    private var hakuba: Hakuba!
    private let disposeBag = DisposeBag()
    
    private var selectedGroup: GroupMessage?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewmodel.fetchGroup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        self.tableview.tableFooterView = UIView()
        self.hakuba = Hakuba(tableView: self.tableview)
        self.hakuba.registerCellByNib(GroupMessageTableViewCell)
        self.hakuba.append(Section())
        
        self.viewmodel.group.asObservable().subscribeNext { groupsModel in
            for group in groupsModel {
                group.selectionHandler = { _ in
                    self.selectedGroup = group.group
                    self.performSegueWithIdentifier("detailMessageSegue", sender: nil)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { 
                self.hakuba[0].reset()
                self.hakuba[0].append(groupsModel)
                self.tableview.reloadData()
            })
        }.addDisposableTo(self.disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let selectedGroup = self.selectedGroup else {
            return
        }
        if segue.identifier == "detailMessageSegue" {
            let controller = segue.destinationViewController as! DetailMessageViewController
            controller.viewModel = MessageViewModel(group: selectedGroup)
        }
    }
}
