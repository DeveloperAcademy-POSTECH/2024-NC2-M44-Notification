# 📱 DiaryNotification
NC2 Notification study of Ace and Groo

## 🖼️ Prototype

### 기본 prototype

학생이 일기를 작성하고 제출하면 선생님이 일기를 확인하고 도장을 찍는다.

https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M44-Notification/assets/77305722/7ee52c02-8fb1-4a8d-86d2-dcdad94f0124

### Local notification

학생이 지정한 시간에 일기 작성 알림을 받는다. 꾹 눌러서 앱에 들어가지 않고도 일기를 작성할 수 있다.

https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M44-Notification/assets/77305722/d6b8c9c0-f0ab-48da-90da-2cec1bd7aa2a

### Remote notification

학생이 일기를 제출하면 선생님에게 일기의 내용이 담긴 알림이 전송된다.

https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M44-Notification/assets/77305722/c049a275-4fc9-452a-babd-0d2bc425f874

## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Notification

### Local Notification

시간, 공간이라는 trigger를 이용하여 디바이스로 알림을 보낸다. notification을 통해 사용자에게 적절한 때에 적절한 형태 알림을 제공함으로써 단순히 리마인드가 아닌 특정 행동을 권유할 수 있다.

### Remote Notification

원격에서 특정 트리거가 발생하면 어플리케이션의 알림을 발생시키는 기술이다.

## 🎯 What we focus on?

- **Trigger**: Local Notification의 경우 시간, 공간을 Trigger 로 사용하여 알림을 줄 수 있다. 그 중 시간이 계획과 밀접하기도 하고, 시간이더라도 타이머, 특정 날짜, 특정 시간 등에 따라 달리 알람을 설정할 수 있어서 앱의 use case의 적절한 알림을 구현하고자 했다.
- **Notification Action**: 알림을 받고 단순히 앱으로 접근하는 것이 아니라, 앱에 들어오지 않아도 미리 설정한 과정을 실행할 수 있게 하여 사용자의 편리성을 높이고 목적에 부합하는 알림을 보내고자 했다.
- **Text Input Action:** Notification action 중에 버튼을 클릭하는 것에서만 끝나는 게 아니라 바로 필요한 텍스트를 입력할 수 있는 것으로, use case에 적절한 알림을 구현하고자 했다.
- **Remote Notification** 의 경우 서버에서 원하는 대로 trigger를 지정할 수 있다. 사용자 상호작용에 맞춰 알림을 전송하기 위해서는 필수이다. 푸시 알림을 구현하기 위해서는 APNs 를 포함한 여러 단계를 거쳐야 하는데, 해당 인프라를 구축하는 법에 대해 집중했다.

## 💼 Use Case

> 적절한 알림을 주어 학생은 일정한 시간에 일기를 작성하고, 선생님은 학생이 제출한 일기를 확인하게 하자.

## 🛠️ About Code

### Local Notification

---

**시간을 trigger로 알림 설정하기**

```swift
let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date) 
trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
```

**보내는 알림의 category 설정하기**

```swift
let textAction = UNTextInputNotificationAction(
    identifier: "TEXT_ACTION",
    title: "간단하게 일기 쓰기",
    options: [],
    textInputButtonTitle: "제출",
    textInputPlaceholder: "일기를 입력해주세요"
)

let basicNotificationCategory = UNNotificationCategory(
    identifier: "STUDENT_NOTIFICATION",
    actions: [textAction, acceptAction],
    intentIdentifiers: [],
    hiddenPreviewsBodyPlaceholder: "일기를 입력해주세요",
    options: .customDismissAction
)
```

**수신한 알림의 category에 따라 action 설정하기**

```swift
func userNotificationCenter(
	_ center: UNUserNotificationCenter,
	didReceive response: UNNotificationResponse,
	withCompletionHandler completionHandler: @escaping () -> Void
) { 
	if response.notification.request.content.categoryIdentifier == "STUDENT_NOTIFICATION" { 
		switch response.actionIdentifier { 
			case "TEXT_ACTION": 
				print("didReceive: text input”)
				if let userInput = (response as? UNTextInputNotificationResponse)?.userText { 
					print(userInput) 
					UserDefaults.standard.set(userInput, forKey: "diary") 
					UserDefaults.standard.set(true, forKey: "isDiarySubmitted") 
					// …
```

### Remote Notification

---

**APNs 등록 후 디바이스 토큰 요청**

```swift
application.registerForRemoteNotifications()
```

**디바이스 토큰 DB 서버에 저장**

```swift
private func saveUserTokenToFirestore(userId: String, token: String) {
   db.collection("users").document(userId).
       setData(["fcmToken": token], merge: true) { error in
       // ..
   }
}
```

**FCM 토큰 생성**

```swift
func messaging(_ messaging: Messaging,
               didReceiveRegistrationToken fcmToken: String?) {
	let dataDict: [String: String] = ["token": fcmToken ?? ""]
	NotificationCenter.default.post(
		name: Notification.Name("FCMToken"),
    object: nil,
    userInfo: dataDict
  )
}
```

**Firebase Functions 호출**

```swift
func sendNotificationToUser
    (userId: String,title: String, body: String) {
    let data: [String: Any] = [
        "userId": userId,
        "title": title,
        "body": body
    ]
    functions.httpsCallable("sendNotification").call(data)
        { result, error in
        //..
    }
}
```

**Firebase Function 에서 알림 전송 (JavaScript)**

```jsx
exports.sendNotification = onCall(async (data, context) => {
    const { userId, title, body } = data;
    //..
    const userDoc = await getFirestore().
                         collection('users').doc(userId).get();
    const fcmToken = userDoc.data().fcmToken;
    const message = {
        notification: {
            title: title,
            body: body
        },
        token: fcmToken
    };
        await admin.messaging().send(message);
		    //..
    }
}
```

## :people_hugging: Authors

|<img src="https://avatars.githubusercontent.com/u/82134672?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/77305722?v=4" width="150" height="150"/>|
|:-:|:-:|
|Groo<br/>[@treesofgroo](https://github.com/treesofgroo)|이상현 Ace<br/>[@dgh06175](https://github.com/dgh06175)|
