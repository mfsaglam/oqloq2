//
//  CreateRoutineViewModel.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import SwiftUI

class CreateRoutineViewModel: ObservableObject {
    /// Why a routine could not be saved.
    ///
    /// Every one of these used to end the same way: nothing was written and
    /// the screen closed as though it had been.
    enum SaveError: LocalizedError, Equatable {
        /// Start and end are the same instant, so no time is allocated.
        case noDuration
        /// The chosen colour could not be converted to a hex string, which
        /// previously made `saveRoutine()` quietly do nothing.
        case unreadableColor
        case storeFailed(String)

        var errorDescription: String? {
            switch self {
            case .noDuration:
                return NSLocalizedString("createRoutine_error_noDuration", comment: "")
            case .unreadableColor:
                return NSLocalizedString("createRoutine_error_color", comment: "")
            case .storeFailed(let reason):
                return NSLocalizedString("createRoutine_error_saveFailed", comment: "") + " " + reason
            }
        }
    }

    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var routineColor = Color.random

    private var interactor: RoutineService

    init(interactor: RoutineService) {
        self.interactor = interactor
        do {
            let lastEndTime = try interactor.loadRoutines().last?.endTime
            startTime = lastEndTime ?? Date()
            endTime = lastEndTime?.addingTimeInterval(3600) ?? Date().addingTimeInterval(3600)
        } catch {
            print("[oqloq] Could not read routines to prefill the form: \(error)")
        }
    }

    /// A routine is a window of time, so it needs two different times. The
    /// times are compared by hour and minute, because only the time of day is
    /// stored; the date the pickers happen to carry is irrelevant.
    var hasDuration: Bool {
        let calendar = Calendar.current
        let start = calendar.dateComponents([.hour, .minute], from: startTime)
        let end = calendar.dateComponents([.hour, .minute], from: endTime)
        return start != end
    }

    /// Shown in the form while the routine cannot be saved, so the disabled
    /// save button is never unexplained.
    var validationMessage: String? {
        hasDuration ? nil : SaveError.noDuration.errorDescription
    }

    func saveRoutine() throws {
        guard hasDuration else { throw SaveError.noDuration }
        guard let colorHex = routineColor.toHex() else { throw SaveError.unreadableColor }

        let routine = RoutineDTO(startTime: startTime, endTime: endTime, color: colorHex)
        do {
            try interactor.saveRoutine(routine: routine)
        } catch {
            throw SaveError.storeFailed(error.localizedDescription)
        }
    }
}
