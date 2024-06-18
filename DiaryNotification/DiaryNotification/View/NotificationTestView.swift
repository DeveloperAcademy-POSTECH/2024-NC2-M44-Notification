//
//  NotificationTestView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI
import NotificationCenter

struct NotificationTestView: View {
    @State private var selectedTime = Date()
    let notify = NotificationHandler.instance
    
    var body: some View {
        VStack {
            Spacer()
            Button("Send a notification in 5 seconds") {
                notify.sendNotification(date: Date(), type: "timeInterval", timeInterval: 5, title: "Time Notification", body: "This is timeinterval notification")
            }
            DatePicker("Pick noti time: ", selection: $selectedTime, in: Date()...)
            Button("Send a notification at time") {
                notify.sendNotification(date: selectedTime, type: "calendar", title: "Date Notification", body: "This is calendar notification")
            }
            Spacer()
            Text("Not working?")
//            Button("Request permissions") {
//                notify.askPermission()
//            }
        }
        .padding()
    }
}

#Preview {
    NotificationTestView()
}
