//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var presentableRoutines: [PresentableRoutine] = []
    
    var data: [RoutineDTO] = []
    
    func getData() {
        self.data = [
            .init(
                startTime: .init(timeIntervalSince1970: 1722888000),
                endTime: .init(timeIntervalSince1970: 1722747600),
                color: "ff3b30"
            ),
            .init(
                startTime: .init(timeIntervalSince1970: 1722747600),
                endTime: .init(timeIntervalSince1970: 1722762000),
                color: "007aff"
            ),
            .init(
                startTime: .init(timeIntervalSince1970: 1722762000),
                endTime: .init(timeIntervalSince1970: 1722776400),
                color: "4cd964"
            ),
            .init(
                startTime: .init(timeIntervalSince1970: 1722776400),
                endTime: .init(timeIntervalSince1970: 1722888000),
                color: "5856d6"
            )
        ]
        
        self.presentableRoutines = data.map { $0.presentable }
    }
}

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                
                VStack {
                    OqloqView(routines: vm.presentableRoutines)
                        .padding()
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
                    CreateRoutineView()
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

#Preview {
    NavigationStack {
        HomeView()
    }
}
