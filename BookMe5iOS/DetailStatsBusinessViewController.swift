//
//  DetailStatsBusinessViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 07/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import RxSwift
import SwiftMoment

struct StatHit {
    let type: Int
    let date: NSDate

    init?(json: JSON) {
        guard let date = json["date"] as? String, let type = json["type"] as? Int else {
            return nil
        }
        self.date = moment(date)?.date ?? NSDate()
        self.type = type
    }
}

struct Stats {

    let hits: [StatHit]
    let owner: String

    init?(json: JSON) {
        guard let owner = json["owner"] as? String, let stats = json["hits"] as? [JSON] else {
            return nil
        }
        self.hits = stats.flatMap({ json -> StatHit? in
            return StatHit(json: json)
        })
        self.owner = owner
    }
}

class DetailStatsBusinessViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let stat = Variable<Stats?>(nil)
    var business: Buisiness!
    private var hakuba: Hakuba!
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hakuba = Hakuba(tableView: self.tableview)
        self.tableview.tableFooterView = UIView()
        self.hakuba.append(Section())
        self.hakuba.registerCellsByNib(ChartTableViewCell)
        self.hakuba.registerCellByNib(DetailLocationTableViewCell)
        self.hakuba.registerCellByNib(DescriptionTableViewCell)
        self.hakuba.registerCellByNib(PictureDetailTableViewCell)

        self.title = self.business.name

        if let image = self.business?.pictures?.first  {
            let model = PictureDetailCellViewModel(image: image)
            self.hakuba[0].append(model)
        }

        if let description = self.business!.description  {
            let model = DescriptionCellViewModel(description: description)
            self.hakuba[0].append(model)
        }

        let model = DetailLocationCellViewModel()
        model.location = self.business?.location
        self.hakuba[0].append(model)


        let requestBookings = APIBookMe5.GetBookings(id: self.business.id)
        Network.send(request: requestBookings, debug: true).subscribeNext { response in
            guard let response = response else {
                return
            }
            print(response)
            print(response)
            }.addDisposableTo(self.disposeBag)

        let request = APIBookMe5.GetStatisticChart
        Network.send(request: request, debug: true).subscribeNext { response in
            guard let response = response else {
                return
            }
            guard let objects = response["objects"] as? [JSON] else {
                return
            }
            self.stat.value = objects.flatMap({ json -> Stats? in
                return Stats(json: json)
            }).filter({ stat -> Bool in
                return stat.owner == self.business.id
            }).first
            }.addDisposableTo(self.disposeBag)

        self.stat.asObservable().subscribeNext { stat in
            guard let stat = stat else {
                return
            }
            let model = ChartTableViewCellModel(content: stat)
            self.hakuba[0].append(model)
            self.tableview.reloadData()
            }.addDisposableTo(self.disposeBag)
    }
}
