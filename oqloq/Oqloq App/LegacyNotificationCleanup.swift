//
//  LegacyNotificationCleanup.swift
//  oqloq
//

import UserNotifications

/// Removes the repeating routine notifications that earlier versions
/// scheduled.
///
/// Deleting the scheduling code is not enough on its own: those requests were
/// registered with the system as repeating daily triggers and keep firing
/// after the update until this app withdraws them.
///
/// `removeAllPendingNotificationRequests` is scoped to this app's own
/// requests. It cannot affect other apps' notifications, and it does not
/// touch authorisation state or any unrelated system permission. Note that an
/// already-granted notification authorisation cannot be revoked
/// programmatically, so the app may still appear under Settings >
/// Notifications with nothing left to deliver.
enum LegacyNotificationCleanup {
    static let completionFlagKey = "com.oqloq.didRemoveLegacyNotifications"

    static func runOnce(defaults: UserDefaults = .standard,
                        center: UNUserNotificationCenter = .current()) {
        guard !defaults.bool(forKey: completionFlagKey) else { return }
        center.removeAllPendingNotificationRequests()
        defaults.set(true, forKey: completionFlagKey)
    }
}
