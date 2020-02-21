//
//  AppDelegate.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import UIKit

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setInitialViewController()
       
        return true
    }
    
    private func setInitialViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: PostListingViewController.reuseID) as? PostListingViewController else { return }
        let navigationViewController = UINavigationController(rootViewController: controller)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}

