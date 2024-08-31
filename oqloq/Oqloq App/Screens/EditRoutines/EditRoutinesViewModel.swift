//
//  EditRoutinesViewModel.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import Foundation

class EditRoutinesViewModel: ObservableObject {
    @Published var routines: [RoutineDTO] = []
    
    private let interactor: RoutinePersistenceInteractor
    
    init(interactor: RoutinePersistenceInteractor) {
        self.interactor = interactor
    }
    
    func loadRoutines() {
        do {
            let data = try interactor.loadRoutines()
            routines = data
        } catch {
            print(error)
        }
    }
    
    func delete(atOffsets indexSet: IndexSet) {
        do {
            try indexSet.forEach { index in
                let routine = routines[index]
                try interactor.deleteRoutine(routine)
                NotificationCenter.shared.cancelScheduledNotification(with: routine.id.uuidString)
            }
            routines.remove(atOffsets: indexSet)
        } catch {
            print(error)
        }
    }
}
