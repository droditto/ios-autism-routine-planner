//
//  ContentView.swift
//  Rutinas
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        DailyRoutinesView()
    }
}

#Preview {
    ContentView()
        .environmentObject(SampleData.shared.user)
        .modelContainer(SampleData.shared.modelContainer)
    // .modelContainer(for: [Flashcard.self, Routine.self, User.self], inMemory: true)
}
