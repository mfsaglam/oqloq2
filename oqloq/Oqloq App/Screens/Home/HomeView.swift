//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel(interactor: RealmPersistenceInteractor())

    @State private var isSheetPresented = false
    
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
                Button(action: {
                    isSheetPresented.toggle()
                }) {
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
        .sheet(isPresented: $isSheetPresented) {
            EditRoutinesView()
        }
        .onAppear {
            vm.getData()
        }
        .onChange(of: isSheetPresented, perform: { value in
            vm.getData()
        })
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
