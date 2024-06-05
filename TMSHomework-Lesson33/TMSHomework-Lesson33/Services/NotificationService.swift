//
//  NotificationService.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 7.04.24.
//

import Foundation
import UserNotifications

class NotificationService: NSObject {
    
    private override init() { }
    static let shared = NotificationService()
    
    let UNCurrentCenter = UNUserNotificationCenter.current()
    
    func authorizeNotification() {
        
        let options:UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNCurrentCenter.requestAuthorization(options: options) { (granted, error) in
             print(error ?? "No errors")
            
            guard granted else {
                print("User Denied the permission to receive Push")
                return
            }
            
            self.UNCurrentCenter.delegate = self
        }
    }
    
    func requestDateNotification(currentDate: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Notification")
        content.body = String(localized: "Time is out. Need to relogin.")
        content.sound = UNNotificationSound.default

        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        dateComponents.second! += 30
        print(dateComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "second", content: content, trigger: trigger)
        
        self.removeAllPendingNotifications()
        self.UNCurrentCenter.add(request)
        print("current date: \(currentDate)")
    }
    
    func removeAllPendingNotifications() {
        self.UNCurrentCenter.removeAllPendingNotificationRequests()
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        LoginService.shared.signOut()
        
        let options: UNNotificationPresentationOptions = [.banner, .sound]
        completionHandler(options)
    }
}
