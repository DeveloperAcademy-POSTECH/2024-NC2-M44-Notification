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
                Text("선생님의 도장을 기다리는 중이에요")
            } else {
                TextField("diary", text: $diaryInput, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.customYellow.opacity(0.2))
                    )
                    .padding(.vertical)
                Spacer()
                Button(action: {
                    print(diaryInput)
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
