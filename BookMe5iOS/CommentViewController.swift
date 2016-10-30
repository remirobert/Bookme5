//
//  CommentViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 30/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Commentaire"
        self.textview.becomeFirstResponder()
    }
}
