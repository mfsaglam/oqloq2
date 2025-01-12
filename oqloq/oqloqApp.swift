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
    init() {
        // Migrate existing Realm data to the shared container
        migrateRealmToSharedContainer()
        // Use the shared container as the default Realm location
        setSharedRealmAsDefault()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .onAppear {
                        NotificationCenter.shared.requestNotificationPermissions()
                    }
            }
        }
    }
}
