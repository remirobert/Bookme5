//
//  MainTabBarViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 13/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import SocketIO

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
        
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController is MessageViewController {
            if let _ = TokenAccess.accessToken {
                return true
            }
            return false
        }
        else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.connect()
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        self.delegate = self
        
        self.tabBar.items?.first!.image = UIImage(named: "homeButton")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?.first!.selectedImage = UIImage(named: "homeButtonSelected")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?.first!.title = "Home"
        
        self.tabBar.items?[1].image = UIImage(named: "profileButton")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[1].selectedImage = UIImage(named: "profileButtonSelected")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[1].title = "Profile"
        
        self.tabBar.items?[2].image = UIImage(named: "messageButton")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "messageButtonSelected")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[2].title = "Messages"
        
        self.tabBar.items?[3].image = UIImage(named: "notificationButton")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[3].selectedImage = UIImage(named: "notificationButtonSelected")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[3].title = "Notifications"
        
        self.tabBar.tintColor = UIColor.whiteColor()
    }
}
