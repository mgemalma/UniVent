//  AppDelegate.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import FBSDKCoreKit
import GoogleMaps
import OneSignal
import SwiftLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Subscribe to significant location updates
        if let _ = launchOptions?[UIApplicationLaunchOptionsKey.location] {
            print("Correct launch options")
            Locator.subscribeSignificantLocations(onUpdate: { newLocation in
                print("New Location: \(newLocation)")
                NSUser.setLocation(loc: newLocation)
            }, onFail: { (err, lastLocation) in
                print("Failed with error: \(err)")
            })
        }
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey("AIzaSyCHWdKuV7jBcB6upYjHs97Oglhk7rGPUD4")
        
        
        // OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "4907fffc-143b-4aeb-a1dc-c1da390f3476",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    // MARK: - Notifications
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        let userDefaults = UserDefaults.standard
        userDefaults.set(deviceTokenString, forKey: "UniVentNewDevID")
       // userDefaults.removeObject(forKey: "UniVentOldDevID")
        
        if let oldIDValue = userDefaults.object(forKey: "UniVentOldDevID") as? String {
            if let newIDValue = userDefaults.object(forKey: "UniVentNewDevID") as? String {
                if oldIDValue != newIDValue {
                    // set old value equal to new val
                    userDefaults.set(newIDValue, forKey: "UniVentOldDevID")
                    // set new value equal to "" to trigger DB connection
                    userDefaults.set("", forKey: "UniVentNewDevID")
                } else {
                    // set both old and new value to be the same
                    userDefaults.set(newIDValue, forKey: "UniVentOldDevID")
                    userDefaults.set(newIDValue, forKey: "UniVentNewDevID")
                }
            }
        } else {
            userDefaults.set(deviceTokenString, forKey: "UniVentOldDevID")
            userDefaults.set("", forKey: "UniVentNewDevID")
            // Send new device ID to database
        }
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received from user while the application is in background/foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        /*Note that this callback will only be invoked whenever the user has either clicked or swiped to interact with your push notification from the lock screen / Notification Center, or if your app was open when the push notification was received by the device.*/
        
        
      // "data" contains anything we send from the backend, need to figure out what data we are recieving. Maybe EventID?
        
        // Print notification payload data
        var eventToSendTo: String = "no event id"
        print("Push notification received: \(data)")
        for i in data {
            if i.key as? String == "eventID" {
                eventToSendTo = i.value as! String
            }
        }
        
        print(eventToSendTo)
        let vc = self.window?.rootViewController
        print(vc?.title)
        let pvc = vc?.storyboard?.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController
        NSEvent.getEventDB(ID: eventToSendTo) { eventData in
            if eventData != nil {
                let addressComponents = dicter(string: eventData?["addr"])!
                
                let eventToLoad = NSEvent(id: eventData?["id"], start: Date(timeIntervalSince1970: Double((eventData?["startT"]!)!)!), end: Date(timeIntervalSince1970: Double((eventData?["endT"]!)!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double((eventData?["latitude"]!)!)!, longitude: Double((eventData?["longitude"]!)!)!), rat: Float((eventData?["rat"]!)!)!, ratC: Int((eventData?["ratC"]!)!)!, flags: Int((eventData?["flags"]!)!)!, heads: Int((eventData?["heads"]!)!)!, host: eventData?["host"], title: eventData?["title"], type: eventData?["type"], desc: eventData?["descr"], intrests: arrayer(string: eventData?["interests"]) as? [String], addr: addressComponents)
                
                pvc?.setupViewFor(event: eventToLoad)
                
                // TODO: Maybe check if we need to run boot on the user before loading
                
                
                vc?.present(pvc!, animated: true)
            }
        }
    }
    
    
    
    
    
    
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "UniVent")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

