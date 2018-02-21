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
            UIApplication.shared.applicationIconBadgeNumber = 0
        })
    }

    func registerForPushNotifications(completion: ((Bool) -> Void)?) {
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

    func requestNotification(forMovie movie: Movie) {
        Api.createNotification(withDeviceId: getDeviceId(), imdbId: movie.imdbId) { movies in
            DataStore.shared.upcoming = movies
        }
    }

    func deleteNotification(forMovie movie: Movie) {
        Api.deleteNotification(withDeviceId: getDeviceId(), imdbId: movie.imdbId) { movies in
            DataStore.shared.upcoming = movies
        }
    }
}
