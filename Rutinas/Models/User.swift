//
//  User.swift
//  Rutinas
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class User: ObservableObject, Identifiable {
    var id: UUID = UUID()
    var currentStreak: Int
    var lastStreakDate: Date?
    var coinBalance: Int
    var preferredFontDesign: String
    
    init(currentStreak: Int = 0, lastStreakDate: Date? = nil, coinBalance: Int = 0, preferredFontDesign: String = "default") {
        self.currentStreak = currentStreak
        self.lastStreakDate = lastStreakDate
        self.coinBalance = coinBalance
        self.preferredFontDesign = preferredFontDesign
    }
    
    var isStreakRenewedToday: Bool {
        guard let lastDate = lastStreakDate else {
            return false
        }
        return Calendar.current.isDateInToday(lastDate)
    }
        
    var fontDesign: Font.Design {
        switch preferredFontDesign.lowercased() {
        case "serif":      .serif
        case "rounded":    .rounded
        case "monospaced": .monospaced
        default:           .default
        }
    }
    
    func canSpend(_ amount: Int) -> Bool {
        amount > 0 && amount <= coinBalance
    }
    
    func spend(_ amount: Int) {
        guard canSpend(amount) else { return }
        coinBalance -= amount
    }
}
