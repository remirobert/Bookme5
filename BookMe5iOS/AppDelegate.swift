//
//  AppDelegate.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import SocketIO

let socket = SocketIOClient(socketURL: NSURL(string: "https://api.bookme5.com/api:3000")!, config: [
    .Log(true),
    .Reconnects(true),
    .ForcePolling(true),
    .ExtraHeaders(["auth_token":  TokenAccess.accessToken ?? "notoken"])
    ])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var appCoordinator: AppCoordinator = AppCoordinator(window: self.window!)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var error: NSError? = nil
        GGLContext.sharedInstance().configureWithError(&error)
        assert(error == nil, "Error configuring Google services: \(error)")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        TokenAccess.initTokenFromSecureStore()
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.appCoordinator.start()
        
        self.setupApparence()
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {        
        if url.scheme.rangeOfString("com.googleusercontent") != nil {
            let options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                                UIApplicationOpenURLOptionsAnnotationKey: annotation]
            
            return GIDSignIn.sharedInstance().handleURL(url,
                                                        sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
                                                        annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        }
        else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}

extension AppDelegate {
    
    func setupApparence() {
//        let navBar = UINavigationBar.appearance()
//        navBar.opaque = false
//        navBar.shadowImage = UIImage()
//        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        let tabBar = UITabBar.appearance()
        tabBar.opaque = false
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor(red:1, green:0.38, blue:0.21, alpha:1)
    }
}

