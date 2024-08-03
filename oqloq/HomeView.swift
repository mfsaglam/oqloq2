//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

class HomeViewViewModel: ObservableObject {
    @Published var sample: [PresentableRoutine] = []
    
    var data: [RoutineDTO] = []
    
    func getData() {
        self.data = [
            .init(
                startTime: .init(timeIntervalSince1970: 1722888000),
                endTime: .init(timeIntervalSince1970: 1722747600),
                color: .red
            ),
            .init(
                startTime: .init(timeIntervalSince1970: 1722747600),
                endTime: .init(timeIntervalSince1970: 1722762000),
                color: .blue
            ),
            .init(
                startTime: .init(timeIntervalSince1970: 1722762000),
                endTime: .init(timeIntervalSince1970: 1722776400),
                color: .green
            ),
            .init(
                startTime: .init(timeIntervalSince1970: 1722776400),
                endTime: .init(timeIntervalSince1970: 1722888000),
                color: .white
            )
        ]
        
        self.sample = data.map { $0.presentable }
    }
}

struct HomeView: View {
    @StateObject var vm = HomeViewViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                
                VStack {
                    
                    OqloqView(routines: vm.sample)
                        .padding()
                    
                    Text("Routine Name")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                }
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("oqloq")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Edit") {
                    
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("lol")
                } label: {
                    Label(
                        title: { Text("") },
                        icon: { Image(systemName: "plus") }
                    )
                }
            }
        }
        .onAppear() {
            vm.getData()
        }
    }
}

struct RoutineDTO: Identifiable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let color: Color
    
    init(
        id: UUID = UUID(),
        startTime: Date,
        endTime: Date,
        color: Color
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
    }
}

extension RoutineDTO {
    var presentable: PresentableRoutine {
        let calendar = Calendar.current
        let startHour = CGFloat(calendar.component(.hour, from: startTime))
        let startMinute = CGFloat(calendar.component(.minute, from: startTime))
        let endHour = CGFloat(calendar.component(.hour, from: endTime))
        let endMinute = CGFloat(calendar.component(.minute, from: endTime))
        
        let start = (startHour + startMinute / 60.0) / 24.0
        let end = (endHour + endMinute / 60.0) / 24.0
        
        return PresentableRoutine(id: id, start: start, end: end, color: color)
    }
}

#Preview {
    TabView {
        NavigationStack {
            HomeView()
        }
        Text("sda")
        Text("111")
    }
}
