//
//  oqloqApp.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI
import UserNotifications

@main
struct oqloqApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .onAppear {
                        requestNotificationPermissions()
                    }
            }
        }
    }
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
