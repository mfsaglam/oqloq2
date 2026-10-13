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
        runLegacyMigration()
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

    /// Copies pre-SwiftData Realm routines across on first launch after the
    /// update. Left unflagged on failure so a later launch retries, rather
    /// than losing the user's routines to one bad attempt.
    private func runLegacyMigration() {
        do {
            let context = store.appContext
            guard let report = try RealmToSwiftDataMigration.runIfNeeded(context: context) else { return }
            print("[oqloq] Migrated \(report.copied) routine(s) from Realm.")
            if !report.unparseableColors.isEmpty {
                print("[oqloq] \(report.unparseableColors.count) routine(s) have an unparseable colour: \(report.unparseableColors)")
            }
        } catch {
            print("[oqloq] Realm migration failed, will retry next launch: \(error)")
        }
    }
}
