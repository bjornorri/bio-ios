//
//  NotificationManager.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 15/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    private var token: String?

    init() {
        NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil, using: { notification in
            self.sendToken()
        })
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func updateToken(_ token: String) {
        self.token = token
        sendToken()
    }

    func sendToken() {
        guard let token = token else { return }
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        Api.registerDevice(withId: deviceId, apnsToken: token)
    }
}
