//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var presentableRoutines: [PresentableRoutine] = []
    
    private let interactor: RoutinePersistenceInteractor
    var data: [RoutineDTO] = []
    
    init(interactor: RoutinePersistenceInteractor) {
        self.interactor = interactor
    }
    
    func getData() {
        do {
            let routines = try interactor.loadRoutines()
            self.data = routines
        } catch {
            print(error.localizedDescription)
        }
        
        self.presentableRoutines = data.map { $0.presentable }
    }
}

struct HomeView: View {
    @StateObject var vm = HomeViewModel(interactor: RealmPersistenceInteractor())
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.wallpaper
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
                NavigationLink {
                    EditRoutinesView()
                } label: {
                    Label(
                        title: { Text("Edit") },
                        icon: { }
                    )
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
        .onAppear {
            vm.getData()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
