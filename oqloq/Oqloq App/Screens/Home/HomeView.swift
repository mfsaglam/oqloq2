//
//  ContentView.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel(interactor: RealmRoutineService())

    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.wallpaper
                    .ignoresSafeArea()
                
                OqloqView(routines: vm.presentableRoutines)
                    .padding()
                    .padding(.bottom, 100)
            }
        }
        .navigationTitle("oqloq")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    isSheetPresented.toggle()
                }) {
                    Text("home_edit")
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
