//
//  SwiftDataRoutineServiceTests.swift
//  oqloqTests
//

import XCTest
import SwiftData
@testable import oqloq

final class SwiftDataRoutineServiceTests: XCTestCase {

    private func makeService() throws -> (RoutineService, ModelContext) {
        let container = try ModelContainer(
            for: RoutineEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        return (SwiftDataRoutineService(context: context), context)
    }

    private func routine(hour: Int, color: String = "#ff0000") -> RoutineDTO {
        let start = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return RoutineDTO(startTime: start, endTime: start.addingTimeInterval(3600), color: color)
    }

    func test_savedRoutineIsLoadedBack() throws {
        let (service, _) = try makeService()
        let saved = routine(hour: 9)

        try service.saveRoutine(routine: saved)
        let loaded = try service.loadRoutines()

        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.id, saved.id)
        XCTAssertEqual(loaded.first?.color, "#ff0000")
        XCTAssertEqual(loaded.first?.startTime, saved.startTime)
        XCTAssertEqual(loaded.first?.endTime, saved.endTime)
    }

    func test_emptyStoreLoadsNoRoutines() throws {
        let (service, _) = try makeService()
        XCTAssertTrue(try service.loadRoutines().isEmpty)
    }

    /// The arc draw order and the create-form prefill both depend on this
    /// being stable.
    func test_routinesAreOrderedByStartTime() throws {
        let (service, _) = try makeService()
        try service.saveRoutine(routine: routine(hour: 21))
        try service.saveRoutine(routine: routine(hour: 7))
        try service.saveRoutine(routine: routine(hour: 13))

        let hours = try service.loadRoutines().map {
            Calendar.current.component(.hour, from: $0.startTime)
        }

        XCTAssertEqual(hours, [7, 13, 21])
    }

    func test_deleteRemovesOnlyThatRoutine() throws {
        let (service, _) = try makeService()
        let keep = routine(hour: 8)
        let drop = routine(hour: 20)
        try service.saveRoutine(routine: keep)
        try service.saveRoutine(routine: drop)

        try service.deleteRoutine(drop)

        XCTAssertEqual(try service.loadRoutines().map(\.id), [keep.id])
    }

    func test_deletingUnknownRoutineLeavesStoreIntact() throws {
        let (service, _) = try makeService()
        let kept = routine(hour: 8)
        try service.saveRoutine(routine: kept)

        try service.deleteRoutine(routine(hour: 23))

        XCTAssertEqual(try service.loadRoutines().map(\.id), [kept.id])
    }

    /// Colours are the user's data and are stored verbatim; the service does
    /// not validate or rewrite them.
    func test_colorIsStoredVerbatim() throws {
        let (service, _) = try makeService()
        let odd = routine(hour: 10, color: "not-a-hex")

        try service.saveRoutine(routine: odd)

        XCTAssertEqual(try service.loadRoutines().first?.color, "not-a-hex")
    }
}
