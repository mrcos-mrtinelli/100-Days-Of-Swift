//
//  ViewController.swift
//  Project21
//
//  Created by Marcos Martinelli on 1/22/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registerBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        let scheduleBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
        navigationItem.leftBarButtonItem = registerBarButtonItem
        navigationItem.rightBarButtonItem = scheduleBarButtonItem
        
    }
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yay!")
            } else {
                print("d'oh!")
            }
        }
    }
    @objc func scheduleLocal() {
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "someIdentifier"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        //  test interval trigger instead
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "remindLater", title: "Remind me later.", options: [])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
}
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // user info dict
        let userInfo = response.notification.request.content.userInfo
        // read custom string "customData"
        if let customData = userInfo["customData"] as? String {
            let ac = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                ac.title = "Default open action was selected."
                print("default action")
            case "show":
                ac.title = "The Show action was selected."
            case "remindLater":
                ac.title = "The remind me later actions was selected"
                scheduleLocal()
            default:
                print(customData)
                break
            }
            
            present(ac, animated: true, completion: nil)
        }
        
        completionHandler()
        
    }
}
