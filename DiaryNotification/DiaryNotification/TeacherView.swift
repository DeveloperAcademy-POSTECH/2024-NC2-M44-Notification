//
//  TeacherView.swift
//  DiaryNotification
//
//  Created by Groo on 6/14/24.
//

import SwiftUI

struct TeacherView: View {    var body: some View {
        VStack {
            Text("diary")
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
        }
        .padding()
    }
}

#Preview {
    TeacherView()
}
