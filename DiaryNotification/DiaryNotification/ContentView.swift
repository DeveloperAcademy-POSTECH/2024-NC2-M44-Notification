//
//  ContentView.swift
//  DiaryNotification
//
//  Created by 이상현 on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentView = "학생"
    let users = ["학생", "선생님"]
    var body: some View {
        VStack {
            Picker("user", selection: $currentView) {
                ForEach(users, id: \.self) { user in
                    Text("\(user)")
                }
            }
            if currentView == "학생" {
                StudentView()
            } else {
                TeacherView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
