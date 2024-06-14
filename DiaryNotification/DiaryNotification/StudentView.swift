//
//  StudentView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI

struct StudentView: View {
    @State private var diaryInput = ""
    var body: some View {
        VStack {
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
        .padding()
    }
}

#Preview {
    StudentView()
}
