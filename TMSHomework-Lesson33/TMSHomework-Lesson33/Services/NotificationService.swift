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
        content.title = "Notification"
        content.body = "Time is out. Need to relogin."
        content.sound = UNNotificationSound.default

        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        dateComponents.day! += 1
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "day", content: content, trigger: trigger)
        
        self.removeAllPendingNotifications()
        self.UNCurrentCenter.add(request)
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
