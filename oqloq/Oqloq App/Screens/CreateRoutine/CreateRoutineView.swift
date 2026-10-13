//
//  CreateRoutineView.swift
//  oqloq
//
//  Created by Fatih Sağlam on 4.08.2024.
//

import SwiftUI

struct CreateRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = CreateRoutineViewModel(interactor: RoutineStore.shared.appService)

    @State private var saveError: String?

    var body: some View {
        Form {
            Section(header: Text("createRoutine_title"), footer: validationFooter) {
                DatePicker("createRoutine_startTime", selection: $vm.startTime, displayedComponents: .hourAndMinute)
                DatePicker("createRoutine_endTime", selection: $vm.endTime, displayedComponents: .hourAndMinute)
            }

            Section(header: Text("createRoutine_routineColor")) {
                ColorPicker("createRoutine_color", selection: $vm.routineColor)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    save()
                } label: {
                    Text("createRoutine_save")
                }
                .disabled(!vm.hasDuration)
            }
        }
        .alert(
            "createRoutine_error_title",
            isPresented: Binding(get: { saveError != nil }, set: { if !$0 { saveError = nil } })
        ) {
            Button("common_ok", role: .cancel) { saveError = nil }
        } message: {
            Text(saveError ?? "")
        }
    }

    @ViewBuilder
    private var validationFooter: some View {
        if let message = vm.validationMessage {
            Text(message)
        }
    }

    /// Only a successful save closes the screen. It used to dismiss whatever
    /// happened, so a failure looked exactly like success.
    private func save() {
        do {
            try vm.saveRoutine()
            presentationMode.wrappedValue.dismiss()
        } catch {
            saveError = error.localizedDescription
        }
    }
}

#Preview {
    NavigationView {
        CreateRoutineView()
    }
}
