//
//  ContentView.swift
//  DiaryNotification
//
//  Created by 이상현 on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentView = "학생"
    @State private var diary = UserDefaults.standard.string(forKey: "diary")!
    @State private var isDiarySubmitted = UserDefaults.standard.bool(forKey: "isDiarySubmitted")
    let users = ["학생", "선생님"]
    var body: some View {
        NavigationStack {
            VStack {
                Picker("user", selection: $currentView) {
                    ForEach(users, id: \.self) { user in
                        Text("\(user)")
                    }
                }
                .tint(.black)
                if currentView == "학생" {
                    StudentView(currentView: $currentView, diary: $diary, isDiarySubmitted: $isDiarySubmitted)
                } else {
                    TeacherView(currentView: $currentView, diary: $diary, isDiarySubmitted: $isDiarySubmitted)
                }
            }
            .padding()
            .toolbar {
                NavigationLink(destination: SettingView(), label: {
                    Image(systemName: "gearshape")
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
