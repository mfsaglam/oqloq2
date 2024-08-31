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
                title: "Your scheduled routine starts now.",
                body: "Do not miss your routines and build your future.",
                id: routine.id.uuidString
            )
        }
    }
}

protocol RoutinePersistenceInteractor {
    func saveRoutine(routine: RoutineDTO) throws
    func loadRoutines() throws -> [RoutineDTO]
    func deleteRoutine(_ routine: RoutineDTO) throws
}

class NotificationCenter {
    static let shared = NotificationCenter()
    
    private init() { }
    
    func scheduleDailyNotification(at hour: Int, minute: Int, title: String, body: String, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled for \(hour):\(minute) with id: \(id)")
            }
        }
    }
    
    func cancelScheduledNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification with identifier \(identifier) cancelled.")
    }
}
