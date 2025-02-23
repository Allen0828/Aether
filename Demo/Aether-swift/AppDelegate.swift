//
//  AppDelegate.swift
//  Aether-swift
//
//  Created by Allen on 2025/2/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }


}

