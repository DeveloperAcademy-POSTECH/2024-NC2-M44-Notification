//
//  NotificationHandler.swift
//  LocalNotificationTest
//
//  Created by Groo on 6/17/24.
//

import Foundation
import UserNotifications

class NotificationHandler: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // UNUserNotificationCenter의 delegate로 NotificationHandler를 지정해줘야 UNUserNotificationCenterDelegate에서 요구한 메서드들이 작동한다
    static let instance = NotificationHandler()
    
    // 참고: singleton
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // 사용자에세 알림 권한을 요청한다
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("permission: access granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // 사용자의 디바이스로 알림을 보낸다
    func sendNotification(date: Date, type: String, timeInterval: Double = 5, title: String, body: String) {
        var trigger: UNNotificationTrigger?
        
        if type == "calendar" { // 특정 날짜, 시간에 알림을 보낸다
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "timeInterval" { // 버튼을 누른 후 timeInterval초 뒤에 알림을 보낸다
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        } else if type == "repeat" { // 설정한 dateComponents마다 알림을 보낸다
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        } else if type == "action" {
//            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
//            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        // 알림의 제목, 내용, 소리를 설정한다
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "LongPop.mp3"))
        if type == "action" {
            setCategories()
            content.categoryIdentifier = "STUDENT_NOTIFICATION"
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // 알림의 카테고리를 설정한다
    func setCategories() {
        print("set: categories")
        // Define the custom actions
        let textAction = UNTextInputNotificationAction(identifier: "TEXT_ACTION", title: "간단하게 일기 쓰기", options: [], textInputButtonTitle: "제출", textInputPlaceholder: "일기를 입력해주세요")
        let acceptAction = UNNotificationAction(identifier: "SKIP_ACTION", title: "이번 일기 건너뛰기", options: [])

        // Define the notification type
        let basicNotificationCategory =
        UNNotificationCategory(identifier: "STUDENT_NOTIFICATION",
                               actions: [textAction, acceptAction],
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "일기를 입력해주세요",
                               options: .customDismissAction)
        // Register the notification type
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([basicNotificationCategory])
    }
    
    // 알림을 받았을 때 알림의 카테고리, 액션에 따라 동작을 수행한다
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
        print("didReceive: userNotificationCenter")
            
       if response.notification.request.content.categoryIdentifier ==
                  "STUDENT_NOTIFICATION" {
          switch response.actionIdentifier {
          case "TEXT_ACTION":
              print("didReceive: text input")
              if let userInput = (response as? UNTextInputNotificationResponse)?.userText {
                  print(userInput)
                  UserDefaults.standard.set(userInput, forKey: "diary")
                  UserDefaults.standard.set(true, forKey: "isDiarySubmitted")
              }
             break
                    
          case "SKIP_ACTION":
             print("didReceive: skip")
              UserDefaults.standard.set("오늘은 일기 쉬는 날!", forKey: "diary")
              UserDefaults.standard.set(true, forKey: "isDiarySubmitted")
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
                "STUDENT_NOTIFICATION" {
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
