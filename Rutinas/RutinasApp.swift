//
//  RutinasApp.swift
//  Rutinas
//

import SwiftUI
import SwiftData

@main
struct RutinasApp: App {
    @StateObject private var user = SampleData.shared.user
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
        .modelContainer(SampleData.shared.modelContainer)
    }
}
