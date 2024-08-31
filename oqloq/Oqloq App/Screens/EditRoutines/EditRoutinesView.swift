//
//  EditRoutinesView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 14.08.2024.
//

import SwiftUI

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
