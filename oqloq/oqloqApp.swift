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
                        NotificationCenter.shared.requestNotificationPermissions()
                    }
            }
        }
    }
}
