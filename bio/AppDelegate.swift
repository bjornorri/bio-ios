//
//  AppDelegate.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import ionicons
import RxSwift

#if DEBUG
    import SimulatorStatusMagic
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-snapshot") {
                SDStatusBarManager.sharedInstance().enableOverrides()
            } else {
                SDStatusBarManager.sharedInstance().disableOverrides()
            }
        #endif
        setRootViewController()
        Fabric.with([Crashlytics.self])
        NotificationManager.shared.setup()
        DataStore.shared.fetchData()
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            NotificationManager.shared.registerForPushNotifications()
        }
        return true
    }

    func setRootViewController() {
        let showtimesVC = UINavigationController()
        let upcomingVC = UINavigationController()
        for navVC in [showtimesVC, upcomingVC] {
            navVC.navigationBar.barTintColor = UIColor.bioGray
            navVC.navigationBar.tintColor = UIColor.white
            navVC.navigationBar.barStyle = .blackTranslucent
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navVC.navigationBar.isHidden = true
        }
        showtimesVC.title = "Sýningar"
        showtimesVC.tabBarItem.image = IonIcons.image(withIcon: ion_ios_videocam, size: 30, color: UIColor.gray)
        showtimesVC.tabBarItem.selectedImage = IonIcons.image(withIcon: ion_ios_videocam, size: 30, color: UIColor.bioYellow)
        showtimesVC.setViewControllers([ShowtimeTableViewController()], animated: false)
        upcomingVC.title = "Væntanlegt"
        upcomingVC.tabBarItem.image = IonIcons.image(withIcon: ion_ios_film, size: 30, color: UIColor.gray)
        upcomingVC.tabBarItem.selectedImage = IonIcons.image(withIcon: ion_ios_film, size: 30, color: UIColor.bioYellow)
        upcomingVC.setViewControllers([UpcomingTableViewController()], animated: false)

        let tabVC = TabBarController()
        tabVC.tabBar.tintColor = UIColor.white
        tabVC.tabBar.barTintColor = UIColor.clear
        tabVC.tabBar.backgroundImage = UIImage()
        tabVC.tabBar.shadowImage = UIImage()
        tabVC.setViewControllers([showtimesVC, upcomingVC], animated: false)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        NotificationManager.shared.updateToken(token)
    }
}

