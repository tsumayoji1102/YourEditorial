//
//  AppDelegate.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit
import CoreData
import RealmSwift
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var daoFactory: DaoFactory!
    // バックグラウンド用
    var backGroundTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        // admob設定
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let config = Realm.Configuration(   
          schemaVersion: 1,
          // 自動的にマイグレーションが実行されます。
          migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
            }
          })

        // デフォルトRealmに新しい設定を適用します
        Realm.Configuration.defaultConfiguration = config

        // Realmファイルを開こうとしたときスキーマバージョンが異なれば、
        // 自動的にマイグレーションが実行されます
        let realm = try! Realm()
        daoFactory = DaoFactory()
        
        // プッシュ通知設定
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        })
        
        let userDefaults = UserDefaults.standard
        
        // 通知設定
        if userDefaults.bool(forKey: "notification"){
            AlertPushNortification.checkAndPush()
        }
        
        // 初回起動時の設定
        if !userDefaults.bool(forKey: "firstLaunch") {
            userDefaults.set(true, forKey: "firstLaunch")
            userDefaults.set(
                ["test":"ca-app-pub-3940256099942544/2934735716",
                 "web": "ca-app-pub-7222703792959850/1845824747",
                 "editorial": "ca-app-pub-7222703792959850/7098151422"],
            forKey: "admobKey")
            userDefaults.set(0, forKey: "clipCount")
            userDefaults.set(false, forKey: "reviewed")
            userDefaults.set(true, forKey: "notification")
            let standardGenre = Genre()
            let date = Date()
            standardGenre.fromDic([
                "genreId": UUID().uuidString,
                "name":"お気に入り",
                "updatedAt":date,
                "createdAt":date
            ])
            try! realm.write {
                realm.add(standardGenre)
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "yourEditorial")
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
    
    // MARK: - AppDelegate Method
        
        
        // バックグラウンドの直前に呼ばれる
        func applicationWillResignActive(_ application: UIApplication) {
            Log.getLog()
            
            self.backGroundTaskId = application.beginBackgroundTask(expirationHandler: {
                [weak self] in
                application.endBackgroundTask((self?.backGroundTaskId)!)
                self?.backGroundTaskId = .invalid
            })
        }
        
        // アプリがアクティブになると呼ばれる
        func applicationDidBecomeActive(_ application: UIApplication) {
            Log.getLog()
            
            application.endBackgroundTask(self.backGroundTaskId)
        }
    }


// 通知デリゲート
extension AppDelegate: UNUserNotificationCenterDelegate{
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
        
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        switch application.applicationState {
        case .active:
            break
            // アプリフォアグラウンド時の処理
        case .inactive:
                
            break
            // アプリバッググラウンド時の処理
        default:
            break
        }
    }
}




