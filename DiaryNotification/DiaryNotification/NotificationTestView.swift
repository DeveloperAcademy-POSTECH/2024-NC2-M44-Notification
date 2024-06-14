//
//  NotificationTestView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI
import NotificationCenter

struct NotificationTestView: View {
    var body: some View {
        VStack {
            Button("request permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .provisional, .sound]) { success, error in
                    if success {
                        print("permission complete")
                    } else {
                        print(error?.localizedDescription ?? "error")
                    }
                }
            }
            Button("show notification") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default

                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)

            }
        }
    }
}

#Preview {
    NotificationTestView()
}
