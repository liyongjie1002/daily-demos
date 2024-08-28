//
//  AppDelegate.swift
//  SwiftDemo1
//
//  Created by xdf on 2024/7/11.
//

import UIKit
import CocoaDebug

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CocoaDebug.enable()
//        print("1")
//
//        DispatchQueue.global().async {
//            print("2")
//            DispatchQueue.main.async {
//                print("3")
//            }
//            DispatchQueue.global().async {
//                print("4")
//            }
//            print("5")
//        }
//
//        print("6")
        
        func value(_ one:Int) ->  (Int) -> Int {
            return {$0 * one}
        }
        
        //调用
        let a = value(2)
        let b = a(3)
        print("最红\(b)")
        
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


    
}

