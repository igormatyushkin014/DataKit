//
//  AppDelegate.swift
//  DataKitDemo
//
//  Created by Igor Matyushkin on 01.07.16.
//  Copyright © 2016 Igor Matyushkin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Class variables & properties
    
    
    // MARK: Public class methods
    
    
    // MARK: Private class methods
    
    
    // MARK: Initializers
    
    
    // MARK: Deinitializer
    
    deinit {
    }
    
    
    // MARK: Object variables & properties
    
    var window: UIWindow?
    
    
    // MARK: Public object methods
    
    
    // MARK: Private object methods
    
    
    // MARK: Protocol methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Create window
        
        let frameForWindow = UIScreen.main.bounds
        window = UIWindow(frame: frameForWindow)
        window!.backgroundColor = .white
        window!.makeKeyAndVisible()
        
        
        // Switch to waiting flow
        
        let waitingViewController = WaitingViewController(nibName: "WaitingViewController", bundle: nil)
        
        let navigationController = UINavigationController(rootViewController: waitingViewController)
        
        window!.rootViewController = navigationController
        
        
        // Fill database
        
        DispatchQueue.global().async {
            let startTimestamp = Date().timeIntervalSince1970
            
            let dispatchGroup = DispatchGroup()
            
            for i in 0..<2000 {
                dispatchGroup.enter()
                
                let user = User()
                user.uniqueIdentifier = String(format: "user-%d", i)
                
                if i % 2 == 0 {
                    user.firstName = "John"
                    user.lastName = "Appleseed"
                } else {
                    user.firstName = "Barack"
                    user.lastName = "Obama"
                }
                
                InMemoryStorage.defaultStorage().tableForObjectWithType(objectType: User.self).insertObject(object: user, withCompletion: {
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                let endTimestamp = Date().timeIntervalSince1970
                let timeResult = endTimestamp - startTimestamp
                NSLog("Filled database in %.3f seconds", timeResult)
                
                InMemoryStorage.defaultStorage().tableForObjectWithType(objectType: User.self).numberOfAllObjectsWithCompletion(completion: { (numberOfObjects) in
                    NSLog("Number of all objects: %d", numberOfObjects)
                })
                
                
                // Switch to main flow
                
                let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
                
                let navigationController = UINavigationController(rootViewController: mainViewController)
                
                self.window!.rootViewController = navigationController
            }
        }
        
        
        // Return result
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

