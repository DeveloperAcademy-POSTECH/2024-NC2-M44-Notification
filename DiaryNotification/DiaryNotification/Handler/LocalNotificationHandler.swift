//
//  NotificationHandler.swift
//  LocalNotificationTest
//
//  Created by Groo on 6/17/24.
//

import Foundation
import UserNotifications

class NotificationHandler {
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("permission: access granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 5, title: String, body: String) {
        var trigger: UNNotificationTrigger?
        if type == "calendar" {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "timeInterval" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        } else if type == "repeat" {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }
        
        let contet = UNMutableNotificationContent()
        contet.title = title
        contet.body = body
        contet.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "LongPop.mp3"))
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: contet, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
