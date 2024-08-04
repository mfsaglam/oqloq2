//
//  CreateRoutineView.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import SwiftUI

struct CreateRoutineView: View {
    @StateObject var vm = CreateRoutineViewModel()

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
                    vm.saveRoutine()
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
    
    func saveRoutine() {
        // message to interactor
    }
}
