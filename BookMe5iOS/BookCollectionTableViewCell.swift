//
//  BookCollectionTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 11/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class BookCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        
        self.collectionViewFlowLayout.itemSize = CGSizeMake(100, 100)
        self.collectionView.dataSource = self
        self.collectionView.registerNib(UINib(nibName: "DetailThumbServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
}

extension BookCollectionTableViewCell: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        return cell
    }
}
