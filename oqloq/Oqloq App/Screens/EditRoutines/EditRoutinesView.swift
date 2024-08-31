//
//  EditRoutinesView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 14.08.2024.
//

import SwiftUI

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

struct EditRoutinesView: View {
    @ObservedObject var vm = EditRoutinesViewModel(interactor: RealmPersistenceInteractor())
    var body: some View {
        List {
            ForEach(vm.routines) { routine in
                RoutineListView(
                    startTime: routine.startTime.formattedTime(),
                    endTime: routine.endTime.formattedTime(),
                    color: .init(hex: routine.color)
                )
            }
            .onDelete(perform: deleteRoutine)
        }
        .onAppear {
            vm.loadRoutines()
        }
    }
    
    func deleteRoutine(at offsets: IndexSet) {
        // show alert to make sure
         vm.delete(atOffsets: offsets)
    }
}

#Preview {
    EditRoutinesView()
}
