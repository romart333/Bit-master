//
//  AppDelegate.swift
//  BitMasterMap
//
//  Created by user167101 on 6/13/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let token = "AIzaSyAJ6BvwElwc17aiYOuGk5mcKp2v24EO6lY"
        GMSServices.provideAPIKey(token)
        
        
        
        // Override point for customization after application launch.
        return true
    }
}

