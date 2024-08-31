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
