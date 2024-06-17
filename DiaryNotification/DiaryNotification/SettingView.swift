//
//  SettingView.swift
//  DiaryNotification
//
//  Created by Groo on 6/17/24.
//

import SwiftUI

struct SettingView: View {
    @State private var selectedDate = Date()
    let notify = NotificationHandler()
    var body: some View {
        VStack {
            Spacer()
            DatePicker("일기 알림 시간: ", selection: $selectedDate, in: Date()...)
            Button("Send a notification at time") {
                notify.sendNotification(date: selectedDate, type: "calendar", title: "Date Notification", body: "This is calendar notification")
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
    SettingView()
}
