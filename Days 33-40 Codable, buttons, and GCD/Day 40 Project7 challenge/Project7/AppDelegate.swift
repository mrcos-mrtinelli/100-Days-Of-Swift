//
//  AppDelegate.swift
//  Project7
//
//  Created by Marcos Martinelli on 12/15/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // I was unable to access the rootViewCotroller here, the if let always failed
    // and I did not get the topRated tabBarItem
    // notice that there is no var window: UIWindow? here anymore
    // this has moved over to the SceneDelegate.swift file
    // https://stackoverflow.com/a/58084612
    // https://www.andrewcbancroft.com/blog/ios-development/ui-work/accessing-root-view-controller-ios13-scenedelegate/

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

