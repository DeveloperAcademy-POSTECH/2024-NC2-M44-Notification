//
//  FirebaseHandler.swift
//  DiaryNotification
//
//  Created by 이상현 on 6/19/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

class FirebaseHandler: ObservableObject {
    static let shared = FirebaseHandler()
    
    private let functions = Functions.functions()
    private let db = Firestore.firestore()
    
    private init() {
        FirebaseApp.configure()
        updateUserToken()
    }
    
    func updateUserToken() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 등록 실패: \(error)")
            } else if let token = token {
                self.saveUserTokenToFirestore(userId: userId, token: token)
            }
        }
    }
    
    private func saveUserTokenToFirestore(userId: String, token: String) {
        db.collection("users").document(userId).setData(["fcmToken": token], merge: true) { error in
            if let error = error {
                print("토큰 저장 실패: \(error.localizedDescription)")
            } else {
                print("토큰 저장 성공")
            }
        }
    }
    
    func sendNotificationToUser(userId: String) {
        functions.httpsCallable("sendNotification").call(["userId": userId]) { result, error in
            if let error = error {
                print("알림 전송 함수 호출 실패: \(error.localizedDescription)")
            } else {
                print("알림 전송 성공")
            }
        }
    }
}
