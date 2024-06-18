//
//  NotificationHandler.swift
//  LocalNotificationTest
//
//  Created by Groo on 6/17/24.
//

import Foundation
import UserNotifications

class NotificationHandler: NSObject, ObservableObject, UNUserNotificationCenterDelegate  {
    // UNUserNotificationCenter의 delegate로 NotificationHandler를 지정해줘야 UNUserNotificationCenterDelegate에서 요구한 메서드들이 작동함.
    static let instance = NotificationHandler()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
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
        } else if type == "action" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "LongPop.mp3"))
        if type == "action" {
            setCategories()
            content.userInfo = ["MEETING_ID" : "meetingID", "USER_ID" : "userID" ]
            content.categoryIdentifier = "BASIC_NOTIFICATION"
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func setCategories() {
        print("set: categories")
        // Define the custom actions.
        let textAction = UNNotificationAction(identifier: "TEXT_ACTION", title: "Input text with keyboard", options: [])
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: [])

        // Define the notification type
        let basicNotificationCategory =
        UNNotificationCategory(identifier: "BASIC_NOTIFICATION",
                               actions: [textAction, acceptAction, declineAction],
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "input text here",
                               options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([basicNotificationCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
        print("didReceive: userNotificationCenter")
            
       if response.notification.request.content.categoryIdentifier ==
                  "BASIC_NOTIFICATION" {
          switch response.actionIdentifier {
          case "TEXT_ACTION":
              print("didReceive: text input")
             break
                    
          case "ACCEPT_ACTION":
             print("didReceive: accept")
             break
                    
          case "DECLINE_ACTION":
            print("didReceive: decline")
             break
                    
          default:
             break
          }
       }
       else {
          // Handle other notification types...
       }
            
       // Always call the completion handler when done.
       completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
             willPresent notification: UNNotification,
             withCompletionHandler completionHandler:
                @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent: userNotificationCenter")
        
       if notification.request.content.categoryIdentifier ==
                "BASIC_NOTIFICATION" {
          // Play a sound to let the user know about the invitation.
          completionHandler(.sound)
          return
       }
       else {
          // Handle other notification types...
       }


       // Don't alert the user for other types.
       completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
}
