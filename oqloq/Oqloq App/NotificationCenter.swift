//
//  NotificationCenter.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import UserNotifications

class NotificationCenter {
    static let shared = NotificationCenter()
    
    private init() {
        // singleton pattern
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyNotification(at hour: Int, minute: Int, id: String) {
        let content = UNMutableNotificationContent()
        content.title = makeNotificationTitle()
        content.body = makeNotificationBody()
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled for \(hour):\(minute) with id: \(id)")
            }
        }
    }
    
    func cancelScheduledNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification with identifier \(identifier) cancelled.")
    }
    
    private func makeNotificationTitle() -> String {
        let notificationTitles = [
            "notificationTitle_1",
            "notificationTitle_2",
            "notificationTitle_3",
            "notificationTitle_4",
            "notificationTitle_5",
            "notificationTitle_6",
            "notificationTitle_7",
            "notificationTitle_8",
            "notificationTitle_9",
            "notificationTitle_10",

        ]
        
        return notificationTitles.randomElement() ?? ""
    }
    
    private func makeNotificationBody() -> String {
        let notificationBodies = [
            "notificationBody_1",
            "notificationBody_2",
            "notificationBody_3",
            "notificationBody_4",
            "notificationBody_5",
            "notificationBody_6",
            "notificationBody_7",
            "notificationBody_8",
            "notificationBody_9",
            "notificationBody_10",
        ]
        
        return notificationBodies.randomElement() ?? ""
    }
}
