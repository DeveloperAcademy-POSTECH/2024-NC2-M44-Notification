//
//  StudentView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI

struct StudentView: View {
    @Binding var currentView: String
    @Binding var diaryInput: String
    @Binding var isDiarySubmitted: Bool
    var body: some View {
        VStack {
            if isDiarySubmitted {
                WaitingView(currentView: currentView)
            } else {
                TextField("diary", text: $diaryInput, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.customYellow.opacity(0.2))
                    )
                    .padding(.vertical)
                Spacer()
                Button(action: {
                    print("submit diary")
                    isDiarySubmitted = true
                }, label: {
                    HStack {
                        Spacer()
                        Text("일기장 제출하기")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.vertical)
                })
                .tint(.customYellow)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

#Preview {
    StudentView(currentView: .constant("학생"), diaryInput: .constant("예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. 예시 입니다. "), isDiarySubmitted: .constant(false))
}
