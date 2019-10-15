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
var postIdFromPush = 0;
var pushNotificationId = 0;
var isAppKilled = true;
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

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
        
        //User Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
                
            }else{
                DispatchQueue.main.async {
                    print ("Notificaiton access success")
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
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
        //let userDefaults = UserDefaults.standard
        //userDefaults.setValue(token , forKey: "tokenData")
        //userDefaults.synchronize()
            

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
        application.applicationIconBadgeNumber = 0
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
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
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(fcmToken , forKey: "tokenData")
        userDefaults.synchronize()

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        
        let userInfo = notification.request.content.userInfo as! NSDictionary;
        //let payloadDict = convertToDictionary(from: userInfo["gcm.notification.payload"]! as! String);
        
        var screen = userInfo["gcm.notification.screen"] as! String
        if(screen == "Home") {
            
            //let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            //var viewContros = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController;
            //viewContros.refreshScreenData();
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
        } else if(screen == "Communication") {
            
            print(UITabBarController().viewControllers?.count)
            
            /*let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewContros = storyBoard.instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
            viewContros.refreshScreenData();*/
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCommunicationScreen"), object: nil)

        } else {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
            
        }

    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo as! NSDictionary
                
        //DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
          //  let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            postIdFromPush = (Int)(userInfo.value(forKey: "gcm.notification.id") as! String)!
            pushNotificationId = (Int)(userInfo.value(forKey: "gcm.notification.notification_id") as! String)!
            if (!isAppKilled) {
                self.window?.rootViewController = HomeViewController.MainViewController();
            }
        //}
        print(userInfo)
    }
        
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.messageID)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("Received: \(userInfo)")
        completionHandler(.newData)
    }

    func convertToDictionary(from text: String) -> [String: String]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String]
        
    }
    
    func showBadgeCount() {
        
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        let jsonURL = "posts/get_notifications_count/format/json"
        var postArray = [String: Any]();
        postArray["user_id"] = String(loggedInUser.userId)
        if (loggedInUser.isCastr == 1) {
            postArray["role_id"] = 0;
        } else {
            postArray["role_id"] = 1;
        }
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 1) {
                let dataArray = response.value(forKey: "data") as! NSDictionary;
                if let tabItems = UITabBarController().tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    var index = 0;
                    if (loggedInUser.isCastr == 1) {
                        index =  3;
                    } else {
                        index = 2;
                    }
                    let tabItem = tabItems[index]
                    let badgeCount = dataArray.value(forKey: "total") as! String
                    print(badgeCount)
                    if (badgeCount != "nil" && badgeCount != "0"){
                        tabItem.badgeValue =  dataArray.value(forKey: "total") as? String;
                    } else {
                        tabItem.badgeValue =  nil;
                    }
                    
                }
            }
        });
    }

}

