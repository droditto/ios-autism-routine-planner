//
//  Flashcard.swift
//  Rutinas
//

import Foundation
import SwiftData

@Model
class Flashcard {
    var id: UUID = UUID()
    var index: Int
    var text: String
    var imageURL: URL
    
    @Relationship(inverse: \Routine.flashcards)
    var routine: Routine?
    
    init(index: Int = 0, text: String = "", imageURL: URL) {
        self.index = index
        self.text = text
        self.imageURL = imageURL
    }
}
