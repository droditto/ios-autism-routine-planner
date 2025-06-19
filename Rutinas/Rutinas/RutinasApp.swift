//
//  RutinasApp.swift
//  Rutinas
//

import SwiftUI
import SwiftData

@main
struct RutinasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SampleData.shared.modelContainer)
    }
}
