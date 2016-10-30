//
//  AppCoordinator.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 10/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

protocol UIViewControllerCoordinable {
    func start()
}

struct AppCoordinator {

    private var window: UIWindow
    private var rootController: UIViewController! {
        didSet {
            self.window.rootViewController = self.rootController
        }
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    mutating func start() {
        self.instanceMainController()
    }
}

extension AppCoordinator {
    
    private mutating func instanceMainController() {
        self.rootController = Storyboards.Main.instantiateMainController()
    }
}
