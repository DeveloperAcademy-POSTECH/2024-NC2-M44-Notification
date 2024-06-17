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
        VStack(spacing: 30) {
            Spacer()
            DatePicker("일기 쓸 시간:", selection: $selectedDate, in: Date()...)
                .font(.title)
            Button("설정한 시간에 알림 받기") {
                notify.sendNotification(date: selectedDate, type: "calendar", title: "일기 쓸 시간!", body: "오늘 일기를 쓸 시간이에요. 알림을 클릭하여 일기를 써 볼까요?")
            }
            .buttonStyle(.borderedProminent)
            .font(.title)
            .tint(.customYellow)
            Spacer()
            Text("알림이 안 보이나요?")
            Button("알림 권한 허용하기") {
                print("set alarm permission")
//                notify.askPermission()
            }
            .font(.title)
            .buttonStyle(.bordered)
            .tint(.customYellow)
        }
        .padding()
    }
}

#Preview {
    SettingView()
}
