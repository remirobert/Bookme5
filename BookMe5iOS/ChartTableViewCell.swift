//
//  ChartTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 07/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import PNChart
import Hakuba
import SwiftMoment

class ChartTableViewCellModel: CellModel {
    var content: Stats

    init(content: Stats) {
        self.content = content
        super.init(cell: ChartTableViewCell.self, height: 220, selectionHandler: nil)
    }
}

class ChartTableViewCell: Cell, CellType {

    typealias CellModel = ChartTableViewCellModel
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    @IBOutlet weak var chartView: PNLineChart!
    @IBOutlet weak var visitBook: UILabel!
    @IBOutlet weak var bookLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }

        self.visitBook.textColor = UIColor.orangeColor().colorWithAlphaComponent(0.5)
        self.visitBook.text = "Visites"
        self.bookLabel.textColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        self.bookLabel.text = "Réservations"

        dispatch_sync(queue) {
            let dates = cellmodel.content.hits.flatMap({ hit -> NSDate? in
                if hit.type == 0 {
                    let moment1String = moment(hit.date).format("MM/dd/yyyy")
                    return moment(moment1String)?.date
                }
                return nil
            })

            let datesBook = cellmodel.content.hits.flatMap({ hit -> NSDate? in
                if hit.type == 1 {
                    let moment1String = moment(hit.date).format("MM/dd/yyyy")
                    return moment(moment1String)?.date
                }
                return nil
            })

            let setVisitDate = NSOrderedSet(array: dates)
            let setBookDate = NSOrderedSet(array: datesBook)

            var visits = [CGFloat]()
            for date in setVisitDate {
                let visitTotal = cellmodel.content.hits.map({ hit -> CGFloat in
                    let moment1 = moment(date as? NSDate ?? NSDate())
                    let moment2 = moment(hit.date)
                    if moment1.month == moment2.month &&
                        moment1.year == moment2.year &&
                        moment1.day == moment2.day &&
                        hit.type == 0 {
                        return 1
                    }
                    return 0
                }).reduce(0, combine: +)
                print("append value : \(visitTotal)")
                visits.append(visitTotal)
            }

            var books = [CGFloat]()
            for date in setBookDate {
                let booktotal = cellmodel.content.hits.map({ hit -> CGFloat in
                    let moment1 = moment(date as? NSDate ?? NSDate())
                    let moment2 = moment(hit.date)
                    if moment1.month == moment2.month &&
                        moment1.year == moment2.year &&
                        moment1.day == moment2.day &&
                        hit.type == 1 {
                        return 1
                    }
                    return 0
                }).reduce(0, combine: +)
                books.append(booktotal)
            }

            let xlabels = setVisitDate.map { date -> String in
                return moment(date as? NSDate ?? NSDate()).format("MM")
            }

            dispatch_async(dispatch_get_main_queue(), { 
                self.chartView.setXLabels(xlabels, withWidth: UIScreen.mainScreen().bounds.size.width / CGFloat(xlabels.count))

                let lineVisit = PNLineChartData()
                lineVisit.itemCount = UInt(visits.count)
                lineVisit.getData = { index in
                    let value = visits[Int(index)]
                    let chart = PNLineChartDataItem(y: value)
                    return chart
                }
                lineVisit.color = UIColor.orangeColor().colorWithAlphaComponent(0.5)

                let lineVisit2 = PNLineChartData()
                lineVisit2.itemCount = UInt(books.count)
                lineVisit2.getData = { index in
                    let value = books[Int(index)]
                    let chart = PNLineChartDataItem(y: value)
                    return chart
                }
                lineVisit2.color = UIColor.redColor().colorWithAlphaComponent(0.5)

                self.chartView.chartData = [lineVisit, lineVisit2]
                self.chartView.strokeChart()
            })
        }
    }
}
