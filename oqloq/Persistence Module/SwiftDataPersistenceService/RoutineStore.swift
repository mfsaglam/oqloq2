//
//  RoutineStore.swift
//  oqloq
//

import Foundation
import SwiftData

/// The app group shared by the app and the widget. Declared in both
/// `oqloq.entitlements` and `oqloqWidgetExtension.entitlements`.
enum AppGroup {
    static let identifier = "group.mfsaglam.routineClock"

    static func containerURL() throws -> URL {
        guard let url = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: identifier
        ) else {
            throw StoreError.appGroupUnavailable(identifier)
        }
        return url
    }
}

enum StoreError: Error, LocalizedError {
    case appGroupUnavailable(String)

    var errorDescription: String? {
        switch self {
        case .appGroupUnavailable(let id):
            return "The app group \(id) is unavailable."
        }
    }
}

/// Owns the SwiftData container for routines, shared by the app and widget.
///
/// The store lives in the app group container so the widget reads the same
/// data. If the group container cannot be reached the store falls back to an
/// in-memory container so the app still launches, and records the failure in
/// `setupFailure` instead of trapping.
final class RoutineStore {
    static let shared = RoutineStore()

    let container: ModelContainer
    /// Non-nil when running on a throwaway in-memory store because the
    /// on-disk store could not be opened. Routines will not persist.
    let setupFailure: Error?

    /// Single context shared by every screen in the app, so a routine saved
    /// on one screen is visible when another refetches. Main-thread only.
    let appContext: ModelContext
    /// Service over `appContext`, for use from the app's views.
    let appService: RoutineService

    private init() {
        let resolved: ModelContainer
        var failure: Error?
        do {
            resolved = try Self.makeSharedContainer()
        } catch {
            failure = error
            resolved = Self.makeInMemoryContainer()
        }
        container = resolved
        setupFailure = failure
        appContext = ModelContext(resolved)
        appService = SwiftDataRoutineService(context: appContext)
    }

    static func storeURL() throws -> URL {
        try AppGroup.containerURL().appendingPathComponent("oqloq.store")
    }

    static func makeSharedContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(url: try storeURL())
        return try ModelContainer(for: RoutineEntity.self, configurations: configuration)
    }

    /// Last resort so a container failure degrades to "no saved routines"
    /// rather than a launch crash.
    private static func makeInMemoryContainer() -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        // A private in-memory store has no external preconditions to fail on.
        return try! ModelContainer(for: RoutineEntity.self, configurations: configuration)
    }

    /// Fresh context for reading outside the app process, such as the widget
    /// timeline provider, which does not run on the main thread.
    func makeSnapshotService() -> RoutineService {
        SwiftDataRoutineService(context: ModelContext(container))
    }
}
