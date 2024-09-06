//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel(interactor: RealmPersistenceInteractor())
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.wallpaper
                    .ignoresSafeArea()
                
                VStack {
                    OqloqView(routines: vm.presentableRoutines)
                        .padding()
                }
            }
        }
        .navigationTitle("oqloq")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                    EditRoutinesView()
                } label: {
                    Label(
                        title: { Text("home_edit") },
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
    NavigationView {
        HomeView()
    }
}
