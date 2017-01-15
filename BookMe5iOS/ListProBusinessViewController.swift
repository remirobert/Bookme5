//
//  ListProBusinessViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 07/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class ListProBusinessViewController: UITableViewController {

    private let disposeBag = DisposeBag()
    private var business = Variable<[Buisiness]>([])

    @IBOutlet weak var dismiss: UIBarButtonItem!

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self

        let idUser = User.sharedInstance.id ?? ""
        let request = APIBookMe5.GetProBusinesses(id: idUser)
        Network.send(request: request).subscribeNext { response in
            guard let response = response else {
                return
            }
            guard let business = response["objects"] as? [JSON] else {
                return
            }

            self.business.value = business.flatMap({ json -> Buisiness? in
                return Buisiness(json: json)
            })
        }.addDisposableTo(self.disposeBag)

        self.business.asObservable().subscribeNext { _ in
            self.tableView.reloadData()
        }.addDisposableTo(self.disposeBag)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let controller = segue.destinationViewController as! DetailStatsBusinessViewController
            controller.business = sender as! Buisiness
        }
    }
}

extension ListProBusinessViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let current = self.business.value[indexPath.row]
        self.performSegueWithIdentifier("detailSegue", sender: current)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.business.value.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let current = self.business.value[indexPath.row]
        cell.textLabel?.text = current.name
        return cell

    }
}
