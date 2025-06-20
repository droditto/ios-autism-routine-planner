//
//  SampleData.swift
//  Rutinas
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    var user: User
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var routine: Routine {
        Routine.sampleData.first!
    }
    
    var flashcard: Flashcard {
        Routine.sampleData.first!.flashcards.first!
    }
    
    private init() {
        let schema = Schema([
            Flashcard.self,
            Routine.self,
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            user = User(currentStreak: 256, lastStreakDate: .now, coinBalance: 1759, preferredFontDesign: "serif")
            
            for routine in Routine.sampleData {
                context.insert(routine)
            }
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
