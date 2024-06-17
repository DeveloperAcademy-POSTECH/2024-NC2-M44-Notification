//
//  NotificationTestView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI
import NotificationCenter

struct NotificationTestView: View {
    @State private var selectedDate = Date()
    let notify = NotificationHandler()
    var body: some View {
        VStack {
            Spacer()
            Button("Send a notification in 5 seconds") {
                notify.sendNotification(date: Date(), type: "time", timeInterval: 5, title: "Time Notification", body: "This is timeinterval notification")
            }
            DatePicker("Pick noti time: ", selection: $selectedDate, in: Date()...)
            Button("Send a notification at time") {
                notify.sendNotification(date: selectedDate, type: "date", title: "Date Notification", body: "This is calendar notification")
            }
            Spacer()
            Text("Not working?")
            Button("Request permissions") {
                notify.askPermission()
            }
        }
        .padding()
    }
}

#Preview {
    NotificationTestView()
}