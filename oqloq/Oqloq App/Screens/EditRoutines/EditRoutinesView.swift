//
//  EditRoutinesView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 14.08.2024.
//

import SwiftUI

struct EditRoutinesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = EditRoutinesViewModel(interactor: RealmPersistenceInteractor())
    @State private var showAlert = false

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
        .toolbar {
            ToolbarItem {
                Button {
                    showAlert = true
                } label: {
                    Text("editRoutines_removeAllButton")
                        .foregroundStyle(.red)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("editRoutines_alert_confirmTitle"),
                        message: Text("editRoutines_alert_confirmMessage"),
                        primaryButton: .destructive(Text("editRoutines_alert_removeAllButton")) {
                            removeAllRoutines()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    func deleteRoutine(at offsets: IndexSet) {
        // show alert to make sure
         vm.delete(atOffsets: offsets)
    }
    
    func removeAllRoutines() {
        vm.deleteAllRoutines()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditRoutinesView()
}
