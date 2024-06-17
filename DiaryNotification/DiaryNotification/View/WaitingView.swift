//
//  WaitingView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI

struct WaitingView: View {
    @State var currentView: String
    var body: some View {
        VStack {
            Spacer()
            Text(currentView == "학생" ? "선생님의 도장을 기다리는 중이에요" : "학생의 일기를 기다리는 중이에요")
            Spacer()
        }
    }
}

#Preview {
    WaitingView(currentView: "학생")
}
