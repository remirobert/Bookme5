//
//  StoryBoard+Extensions.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 26/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

extension UIApplication {

    class func setRootController(controller: UIViewController) {
        if let appDelegate = self.sharedApplication().delegate as? AppDelegate {
            appDelegate.window?.rootViewController = controller
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
