//
//  oqloqApp.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI
import SwiftData

@main
struct oqloqApp: App {
    private let store = RoutineStore.shared

    init() {
        if let failure = store.setupFailure {
            print("[oqloq] Routine store unavailable, running in memory: \(failure)")
        }
        LegacyNotificationCleanup.runOnce()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
        .modelContainer(store.container)
    }
}
