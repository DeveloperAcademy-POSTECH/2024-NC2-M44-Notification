//
//  NotificationTestView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI
import UserNotifications

struct NotificationTestView: View {
    var body: some View {
        VStack {
            Button("Request permission") {
//                let center = UNUserNotificationCenter.current()
//                do {
//                    try await center.requestAuthorization(options: [.alert, .badge, .sound, .provisional])
//                    print("permission success")
//                } catch(Error) {
//                    print(Error.)
//                }
            }
            Button("Show notificatin") {
                
            }
        }
    }
}

#Preview {
    NotificationTestView()
}
