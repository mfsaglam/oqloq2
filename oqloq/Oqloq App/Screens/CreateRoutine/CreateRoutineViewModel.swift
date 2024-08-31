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
    @Published var routineColor = Color.red
    
    private var interactor: RoutinePersistenceInteractor
    
    init(interactor: RoutinePersistenceInteractor) {
        self.interactor = interactor
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
