//
//  AppDelegate.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 16.08.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var initVC: InitViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IAPManager.shared.fetchProducts()
        
        setUpFirebase()
        setInitVC()
        UserDefaultsManager.reg()
        
        UIApplication.shared.isIdleTimerDisabled = true
        application.registerForRemoteNotifications()
        return true
    }
    
    func setInitVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(withIdentifier: "InitViewController") as! InitViewController
        self.initVC = initialVC
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
        
    }
    
    func setUpFirebase() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SegmentManager.handlePushNotification(userInfo)
    }
    
}
