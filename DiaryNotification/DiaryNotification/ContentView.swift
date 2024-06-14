//
//  ContentView.swift
//  DiaryNotification
//
//  Created by 이상현 on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentView = "학생"
    @State private var diary = ""
    @State private var isDiarySubmitted = false
    let users = ["학생", "선생님"]
    var body: some View {
//        VStack {
//            Picker("user", selection: $currentView) {
//                ForEach(users, id: \.self) { user in
//                    Text("\(user)")
//                }
//            }
//            .tint(.black)
//            if currentView == "학생" {
//                StudentView(currentView: $currentView, diaryInput: $diary, isDiarySubmitted: $isDiarySubmitted)
//            } else {
//                TeacherView(currentView: $currentView, diary: $diary, isDiarySubmitted: $isDiarySubmitted)
//            }
//        }
//        .padding()
        NotificationTestView()
    }
}

#Preview {
    ContentView()
}
