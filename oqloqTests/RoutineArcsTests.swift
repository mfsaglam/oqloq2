//
//  RoutineArcsTests.swift
//  oqloqTests
//

import XCTest
import SwiftUI
@testable import oqloq

final class RoutineArcsTests: XCTestCase {

    private func routine(_ start: CGFloat, _ end: CGFloat) -> PresentableRoutine {
        PresentableRoutine(start: start, end: end, color: .red)
    }

    func test_normalRoutineIsOneArc() {
        XCTAssertEqual(
            routine(9.0 / 24, 12.0 / 24).arcs,
            .single(from: 9.0 / 24, to: 12.0 / 24)
        )
    }

    func test_routineCrossingMidnightIsTwoArcs() {
        XCTAssertEqual(
            routine(23.0 / 24, 7.0 / 24).arcs,
            .split(from: 23.0 / 24, to: 0.9999, thenTo: 7.0 / 24)
        )
    }

    /// The rule for equal start and end. It used to fall through to the
    /// midnight branch and paint the whole day.
    func test_equalStartAndEndDrawsNothing() {
        XCTAssertEqual(routine(9.0 / 24, 9.0 / 24).arcs, .empty)
    }

    func test_midnightToMidnightDrawsNothing() {
        XCTAssertEqual(routine(0, 0).arcs, .empty)
    }

    func test_oneMinuteRoutineStillDraws() {
        let start: CGFloat = 9.0 / 24
        let end: CGFloat = (9.0 + 1.0 / 60) / 24
        XCTAssertEqual(routine(start, end).arcs, .single(from: start, to: end))
    }
}

final class ColorHexTests: XCTestCase {

    func test_readsSixDigitHexWithAndWithoutHash() {
        XCTAssertNotNil(Color(hex: "#ff0000"))
        XCTAssertNotNil(Color(hex: "FF0000"))
        XCTAssertNotNil(Color(hex: "  #AaBbCc  "))
    }

    /// These used to trap the app in Debug and silently produce a wrong
    /// colour in Release.
    func test_rejectsMalformedHex() {
        for bad in ["", "#abc", "gghhii", "#1234567", "12345", "not a colour"] {
            XCTAssertNil(Color(hex: bad), "expected \(bad.debugDescription) to be rejected")
        }
    }

    /// Caught a real defect: toHex() truncated instead of rounding, so
    /// #3366cc came back as #3266cc and every saved colour drifted a step.
    func test_hexRoundTrips() throws {
        for hex in ["#3366cc", "#ff0000", "#000000", "#ffffff", "#010203", "#7e8aa2"] {
            let color = try XCTUnwrap(Color(hex: hex))
            XCTAssertEqual(color.toHex(), hex)
        }
    }

    /// A routine drawn in white vanishes against the face, and one in black is
    /// indistinguishable from the indicator.
    func test_randomColorIsNeverWhiteOrBlack() {
        let white = Color.white.toHex()
        let black = Color.black.toHex()
        for _ in 0..<200 {
            let hex = Color.random.toHex()
            XCTAssertNotEqual(hex, white)
            XCTAssertNotEqual(hex, black)
        }
    }
}

@MainActor
final class CreateRoutineViewModelTests: XCTestCase {

    private func makeViewModel() -> (CreateRoutineViewModel, SpyRoutineService) {
        let service = SpyRoutineService()
        return (CreateRoutineViewModel(interactor: service), service)
    }

    private func time(_ hour: Int, _ minute: Int = 0) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }

    func test_savesRoutineWithChosenTimesAndColor() throws {
        let (vm, service) = makeViewModel()
        vm.startTime = time(9)
        vm.endTime = time(11)
        vm.routineColor = .red

        try vm.saveRoutine()

        XCTAssertEqual(service.saved.count, 1)
        XCTAssertEqual(service.saved.first?.color, Color.red.toHex())
    }

    func test_equalTimesCannotBeSaved() {
        let (vm, service) = makeViewModel()
        vm.startTime = time(9)
        vm.endTime = time(9)

        XCTAssertFalse(vm.hasDuration)
        XCTAssertNotNil(vm.validationMessage)
        XCTAssertThrowsError(try vm.saveRoutine()) { error in
            XCTAssertEqual(error as? CreateRoutineViewModel.SaveError, .noDuration)
        }
        XCTAssertTrue(service.saved.isEmpty)
    }

    /// Only the time of day is stored, so two different dates at the same
    /// clock time are still a zero length routine.
    func test_sameClockTimeOnDifferentDaysHasNoDuration() {
        let (vm, _) = makeViewModel()
        vm.startTime = time(9)
        vm.endTime = Calendar.current.date(byAdding: .day, value: 3, to: time(9))!

        XCTAssertFalse(vm.hasDuration)
    }

    func test_differentTimesCanBeSaved() {
        let (vm, _) = makeViewModel()
        vm.startTime = time(9)
        vm.endTime = time(9, 1)

        XCTAssertTrue(vm.hasDuration)
        XCTAssertNil(vm.validationMessage)
    }

    /// A failing store must surface, not look like a successful save.
    func test_storeFailureIsReported() {
        let (vm, service) = makeViewModel()
        vm.startTime = time(9)
        vm.endTime = time(11)
        service.saveError = NSError(domain: "test", code: 1)

        XCTAssertThrowsError(try vm.saveRoutine()) { error in
            guard case .storeFailed = error as? CreateRoutineViewModel.SaveError else {
                return XCTFail("expected storeFailed, got \(error)")
            }
        }
    }
}

private final class SpyRoutineService: RoutineService {
    var saved: [RoutineDTO] = []
    var saveError: Error?

    func saveRoutine(routine: RoutineDTO) throws {
        if let saveError { throw saveError }
        saved.append(routine)
    }
    func loadRoutines() throws -> [RoutineDTO] { saved }
    func deleteRoutine(_ routine: RoutineDTO) throws {
        saved.removeAll { $0.id == routine.id }
    }
}
