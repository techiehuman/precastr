//
//  AppDelegate.swift
//  precastr
//
//  Created by Macbook on 02/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore
import Fabric
import Crashlytics
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

let setting = UserDefaults.standard
var postStatusList = [PostStatus]();
var social : SocialPlatform!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions);

        Fabric.with([Crashlytics.self])
         TWTRTwitter.sharedInstance().start(withConsumerKey:"anwp6W4J66hoUWrB1PX9zMHiu", consumerSecret: "tXOlOLD8gcRQhrux93NcBQOA1v2WE24PcZTb9PrgLSS8c4DUAI")
        UITabBar.appearance().barTintColor = UIColor.init(red:12/255, green:111/255, blue: 233/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.white;
        UINavigationBar.appearance().barTintColor = UIColor.init(red:12/255, green:111/255, blue: 233/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let navbarFont = UIFont(name: "VisbyCF-Medium", size: 20)!
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: navbarFont, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        
        let tabBarFont = UIFont(name: "VisbyCF-Medium", size: 10)!
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: tabBarFont], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: tabBarFont], for: .selected)
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1);
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true

    }
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
             Messaging.messaging().apnsToken = deviceToken
            print("token recieved \(deviceToken.description)")
            
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        print("Registered with device token: \(token)")
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(token , forKey: "tokenData")
        userDefaults.synchronize()
            

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
        
        AppEvents.activateApp();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print(url.absoluteString.contains("fb"))
        
        if (url.absoluteString.contains("fb")) {
            return ApplicationDelegate.shared.application(app
                , open: url
                , options: options)

        } else {
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)

        }
        return true;
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}

