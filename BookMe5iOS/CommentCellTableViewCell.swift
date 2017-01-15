//
//  CommentCellTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 29/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import HCSStarRatingView

class CommentCellModel: CellModel {
    
    let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        super.init(cell: CommentCellTableViewCell.self, height: 40)
    }
}

class CommentCellTableViewCell: Cell, CellType {

    typealias CellModel = CommentCellModel
    
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        let comment = cellmodel.comment
        self.labelContent.text = comment.content
        self.labelAuthor.text = "De \(comment.author ?? "")"
        self.ratingView.hidden = true

        if let mark = comment.mark {
            self.ratingView.value = CGFloat(mark)
            self.ratingView.hidden = false
        }

        cellmodel.height = heightForView(comment.content ?? "", width: UIScreen.mainScreen().bounds.size.width) + 25
    }
}
