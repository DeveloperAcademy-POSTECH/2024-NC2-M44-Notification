//
//  AppDelegate.swift
//  DiaryNotification
//
//  Created by 이상현 on 6/16/24.
//

import UIKit
import UserNotifications
import os.log
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseFunctions

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    private let logger = Logger(subsystem: "ace.DiaryNotification", category: "AppDelegate")
    
    // APNs에 Notifications 등록, 디바이스 토큰 반환
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // 유저에게 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted { // 권한 부여 받음
                self.logger.log("알림 권한 부여 받음")
                DispatchQueue.main.async {
                    // 디바이스 토큰 요청을 위해 APNs 등록
                    application.registerForRemoteNotifications()
                }
            } else {
                self.logger.log("알림 권한 부여 거절")
            }
        }
        return true
    }
    
    // APNs 등록 콜백 함수 - 실패: 토큰이 존재하지 않는다.
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.error("APNs 등록 실패: \(error.localizedDescription)")
    }
    
    // APNs 등록 콜백 함수 - 성공: provider 서버 에게 토큰 전달
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        self.forwardDeviceTokenToServer(deviceToken: deviceToken)
        
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let validToken = token {
                print("FCM registration token: \(validToken)")
                //            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
            }
        }
    }
    
    private func forwardDeviceTokenToServer(deviceToken: Data) {
        // 디바이스 토큰은 Data 형식으로 오기 때문에 문자열로 변환
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let deviceTokenString = tokenParts.joined()
        logger.info("APNs 등록 성공. Device Token: \(deviceTokenString)")
        
        //  문자열을 URLQuery 에 넣어서 endpoint 자격 완성
        let queryItems = [URLQueryItem(name: "deviceToken", value: deviceTokenString)]
        var urlComponents = URLComponents(string: "www.example.com/register")!
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            logger.error("urlComponents.url 이 nil 입니다.")
            return
        }
        
        // 서버의 데이터베이스에 디바이스 토큰 등록
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // TODO: provider 서버에 디바이스 토큰 전송 로직 추가
        }
        task.resume()
    }
    
    // 앱이 포그라운드에 있을 때 푸시 알림 받으면 호출 (배너 사운드 배지로 오도록 함)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // 사용자가 알림을 클릭하면 이 메소드가 호출된다.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let requestContent = response.notification.request.content
        let userInfo = requestContent.userInfo
        
        // 데이터 없을 경우 처리
        guard let special = userInfo["special"] as? String,
              let specialPriceString = userInfo["price"] as? String,
              let specialPrice = Float(specialPriceString) else {
            logger.error("알림 content 없음")
            completionHandler()
            return
        }
        
        print(special) // 데이터 사용 예시 (뷰에 넣거나 등)
        print(specialPriceString) // 데이터 사용 예시 (뷰에 넣거나 등)
        print(specialPrice) // 데이터 사용 예시 (뷰에 넣거나 등)
        
        completionHandler() // 함수 종료 전에 무조건 호출
    }
    
    // Note: 이 콜백은 앱이 처음 시작되거나 새로운 토큰이 생성될때 실행된다.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: Application Server에 토큰 전송하기
    }
}

// 서버에서 보내야 하는 페이로드 형식 (JSON)
//{
//    "aps" : { // 알림을 어떻게 구성해야 하는지에 대한 정보
//        "alert" : { // 알림에 사용할 텍스트
//            "title" : "새로운 게시글 업로드 됨",
//            "body" : "WWDC 2024 요점 정리"
//        },
//        "sound" : "default", // 옵셔널, 알림 왔을때 소리 지정 가능, 커스텀 소리도 가능
//        "badge" : 1, // 옵셔널, 앱 아이콘에 배지 추가
//    },
//    // 나머지 필드에는 아무 커스텀 데이터를 넣을 수 있다.
//    "special" : "avocado_bacon_burger",
//    "price" : "9.99"
//}
