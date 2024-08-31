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
            "Your scheduled routine starts now.",
            "Time to build your habits!",
            "It's routine time—let's get moving!",
            "Stay on track—your routine is waiting.",
            "Consistency is key—let’s do this!",
            "Your future self will thank you!",
            "Small steps lead to big results.",
            "Make today count!",
            "Your journey continues now.",
            "Rise and grind—your routine awaits.",
        ]
        
        return notificationTitles.randomElement() ?? ""
    }
    
    private func makeNotificationBody() -> String {
        let notificationBodies = [
            "Do not miss your routines and build your future.",
            "Every step you take today is progress toward your goal.",
            "Consistency today, success tomorrow.",
            "Remember, it’s the small efforts every day that add up to big changes.",
            "Don’t let this opportunity pass—make it happen!",
            "Stay committed, stay focused, stay strong.",
            "You’re closer to your goal with every routine.",
            "Discipline today means freedom tomorrow.",
            "Your habits shape your destiny—keep pushing forward.",
            "Keep going—your future self will be proud.",
        ]
        
        return notificationBodies.randomElement() ?? ""
    }
}
