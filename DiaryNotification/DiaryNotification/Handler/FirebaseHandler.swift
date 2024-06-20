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

class FirebaseHandler {
    static let shared = FirebaseHandler()
    
    private let functions = Functions.functions()
    private let db = Firestore.firestore()
    
    private init() {
        handleUserAuthentication()
    }
    
    private func handleUserAuthentication() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("익명 로그인 실패: \(error.localizedDescription)")
                    return
                }
                print("익명 로그인 성공: \(authResult?.user.uid ?? "")")
                self.updateUserToken()
            }
        } else {
            print("사용자가 이미 로그인 되어 있습니다: \(Auth.auth().currentUser?.uid ?? "")")
            self.updateUserToken()
        }
    }

    
    func updateUserToken() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 등록 실패: \(error)")
            } else if let token = token {
                print("FCM 토큰 등록 성공: \(token)")
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
    
    func sendNotificationToUser(userId: String, title: String, body: String) {
        let data: [String: Any] = [
            "userId": userId,
            "title": title,
            "body": body
        ]
        functions.httpsCallable("sendNotification").call(data) { result, error in
            if let error = error {
                print("알림 전송 함수 호출 실패: \(error.localizedDescription)")
            } else {
                print("알림 전송 성공")
            }
        }
    }
    
    func testNotification(text: String) {
        let data: [String: Any] = [
            "text": text
        ]
        functions.httpsCallable("addmessage").call(data) { result, error in
            if let error = error {
                print("메시지 추가 함수 호출 실패: \(error.localizedDescription)")
            } else {
                print("메시지 추가 성공: \(result?.data ?? "")")
            }
        }
    }
}
