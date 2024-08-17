//
//  CreateRoutineView.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import SwiftUI

struct CreateRoutineView: View {
    @StateObject var vm = CreateRoutineViewModel(interactor: AnyPersistenceInteractor())

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
                    Task {
                        try? await vm.saveRoutine()
                    }
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
    
    func saveRoutine() async throws {
        if let routine = makeRoutineDTO() {
            try await interactor.saveRoutine(routine: routine)
        }
    }
}

protocol RoutinePersistenceInteractor {
    func saveRoutine(routine: RoutineDTO) async throws
}
