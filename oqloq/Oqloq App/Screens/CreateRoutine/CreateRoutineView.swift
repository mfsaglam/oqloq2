//
//  CreateRoutineView.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import SwiftUI

struct CreateRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = CreateRoutineViewModel(interactor: RealmPersistenceInteractor())

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Routine time")) {
                    VStack {
                        DatePicker("Start Time", selection: $vm.startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $vm.endTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Routine color")) {
                    ColorPicker("Color", selection: $vm.routineColor)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    try? vm.saveRoutine()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateRoutineView()
    }
}

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
