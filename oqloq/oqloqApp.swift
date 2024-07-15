//
//  oqloqApp.swift
//  oqloq
//
//  Created by Saglam, Fatih on 15.07.2024.
//

import SwiftUI

@main
struct oqloqApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    ContentView()
                }
                .tabItem { Text("house") }
                Text("Lol")
                    .tabItem { Text("house") }
                Text("Hello")
                    .tabItem { Text("house") }
            }
        }
    }
}
