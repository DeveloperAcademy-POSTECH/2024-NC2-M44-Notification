//
//  TeacherView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI

struct TeacherView: View {
    @Binding var currentView: String
    @Binding var diary: String
    @Binding var isDiarySubmitted: Bool
    var body: some View {
        VStack {
            if isDiarySubmitted {
                Text(diary)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * 0.9
                    }
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.customBlue.opacity(0.2))
                    )
                    .padding(.vertical)
                Spacer()
                Button(action: {
                    print("stamp")
                    isDiarySubmitted = false
                    diary = ""
                }, label: {
                    HStack {
                        Spacer()
                        Text("일기장 도장 찍기")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.vertical)
                })
                .tint(.customBlue)
                .buttonStyle(.borderedProminent)
            } else {
                WaitingView(currentView: currentView)
            }
        }
        .padding()
    }
}

#Preview {
    TeacherView(currentView: .constant("학생"), diary: .constant("예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. "), isDiarySubmitted: .constant(false))
}
