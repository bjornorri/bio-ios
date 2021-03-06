//
//  NotificationManager.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 15/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {

    static let shared = NotificationManager()

    private var token: String?

    func setup() {
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil, using: { notification in
            self.sendToken()
            UIApplication.shared.applicationIconBadgeNumber = 0
        })
    }

    func registerForPushNotifications(_ completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else {
                if let completion = completion { completion(false) }
                return
            }
            self.getNotificationSettings(completion: completion)
        }
    }

    private func getNotificationSettings(completion: ((Bool) -> Void)?) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                if let completion = completion { completion(false) }
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                if let completion = completion { completion(true) }
                return
            }
        }
    }

    func updateToken(_ token: String) {
        self.token = token
        sendToken()
    }

    func sendToken() {
        guard let token = token else { return }
        Api.registerDevice(withId: getDeviceId(), apnsToken: token)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let link = response.notification.request.content.userInfo["link"] as? String {
            DeepLinkManager.shared.openLink(link)
        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
