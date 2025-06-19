//
//  PictogramOptions.swift
//  Rutinas
//

import Foundation

struct PictogramOptions: Equatable {
    var color = true
    
    var plural = false
    var action: Action? = nil
    var identifier: Identifier? = nil
    var identifierPosition: IdentifierPosition = .left
    
    var skin: Skin? = nil
    var hair: Hair? = nil
    
    enum Action: String, CaseIterable, Identifiable {
        case past, future
        var id: String { rawValue }
    }
    
    enum Identifier: String, CaseIterable, Identifiable {
        case classroom, health, library, office
        var id: String { rawValue }
    }
    
    enum IdentifierPosition: String, CaseIterable, Identifiable {
        case left, right
        var id: String { rawValue }
    }
    
    
    enum Skin: String, CaseIterable, Identifiable {
        case white, black, assian, mulatto, aztec
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .white:   "White"
            case .black:   "Black"
            case .assian:  "Asian"
            case .mulatto: "Mulatto"
            case .aztec:   "Aztec"
            }
        }
    }
    
    enum Hair: String, CaseIterable, Identifiable {
        case blonde, brown, darkBrown, gray, darkGray, red, black
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .blonde:    "Blonde"
            case .brown:     "Brown"
            case .darkBrown: "Dark Brown"
            case .gray:      "Gray"
            case .darkGray:  "Dark Gray"
            case .red:       "Red"
            case .black:     "Black"
            }
        }
    }
}
