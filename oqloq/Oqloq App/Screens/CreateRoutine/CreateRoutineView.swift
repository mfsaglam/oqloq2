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
                Section(header: Text("createRoutine_title")) {
                    VStack {
                        DatePicker("createRoutine_startTime", selection: $vm.startTime, displayedComponents: .hourAndMinute)
                        DatePicker("createRoutine_endTime", selection: $vm.endTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("createRoutine_routineColor")) {
                    ColorPicker("createRoutine_color", selection: $vm.routineColor)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    try? vm.saveRoutine()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("createRoutine_save")
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CreateRoutineView()
    }
}
