//
//  CreateRoutineViewModel.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import SwiftUI

class CreateRoutineViewModel: ObservableObject {
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var routineColor = Color.random
    
    private var interactor: RoutinePersistenceInteractor
    
    init(interactor: RoutinePersistenceInteractor) {
        self.interactor = interactor
        do {
            let lastEndTime = try interactor.loadRoutines().last?.endTime
            startTime = lastEndTime ?? Date()
            endTime = lastEndTime?.addingTimeInterval(3600) ?? Date().addingTimeInterval(3600)
        } catch {
            print(error)
        }
    }
    
    private func makeRoutineDTO() -> RoutineDTO? {
        guard let colorHex = routineColor.toHex() else { return nil }
        return .init(
            startTime: startTime,
            endTime: endTime,
            color: colorHex
        )
    }
    
    func saveRoutine() throws {
        if let routine = makeRoutineDTO() {
            try interactor.saveRoutine(routine: routine)
            NotificationCenter.shared.scheduleDailyNotification(
                at: Calendar.current.component(.hour, from: routine.startTime),
                minute: Calendar.current.component(.minute, from: routine.startTime),
                id: routine.id.uuidString
            )
        }
    }
}
