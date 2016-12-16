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

    private func askLogin() {
        let alert = UIAlertController(title: "Vous devez être logger pour pouvoir accéder à cette fonctionnalité.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { _ in
            self.presentViewController(Storyboards.Main.instantiateLoginController(), animated: true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        guard let viewController = viewController as? UINavigationController else {
            return true
        }
        if viewController.topViewController is MessageViewController ||
            viewController.topViewController is ProfileViewController ||
            viewController.topViewController is NotificationViewController {
            if let _ = TokenAccess.accessToken {
                return true
            }
            self.askLogin()
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

        let selectedColor   = UIColor.blackColor()
        let unselectedColor = UIColor.lightGrayColor()

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], forState: .Selected)
        
        self.tabBar.items?.first!.image = UIImage(named: "shop-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?.first!.selectedImage = UIImage(named: "shop-on")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?.first!.title = "Home"
        
        self.tabBar.items?[1].image = UIImage(named: "maintabbar2-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[1].selectedImage = UIImage(named: "maintabbar2-on")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[1].title = "Profile"
        
        self.tabBar.items?[2].image = UIImage(named: "message-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "message-on")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[2].title = "Messages"
        
        self.tabBar.items?[3].image = UIImage(named: "notification-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[3].selectedImage = UIImage(named: "notification-on")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[3].title = "Notifications"
        
        self.tabBar.tintColor = UIColor.whiteColor()
    }
}
