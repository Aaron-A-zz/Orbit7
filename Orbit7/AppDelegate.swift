//
//  AppDelegate.swift
//  Orbit7
//
//  Created by James Martinez on 2/7/15.
//  Copyright (c) 2015 Aaron Ackerman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Properties

  lazy var window: UIWindow = {
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.backgroundColor = UIColor.whiteColor()
    window.rootViewController = GameViewController()
    return window
    }()

  // MARK: - UIApplicationDelegate

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window.makeKeyAndVisible()
    return true
  }
}