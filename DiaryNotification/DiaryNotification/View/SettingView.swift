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
                notify.sendNotification(date: selectedDate, type: "calendar", title: "일기 쓸 시간!", body: "오늘 일기를 쓸 시간이에요. 알림을 클릭하여 일기를 써 볼까요?")
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
    SettingView()
}
