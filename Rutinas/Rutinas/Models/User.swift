//
//  User.swift
//  Rutinas
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class User: Identifiable {
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
    
    func preferredFont(textStyle: Font.TextStyle = .body) -> Font {
        let design: Font.Design
        switch preferredFontDesign.lowercased() {
        case "rounded":    design = .rounded
        case "serif":      design = .serif
        case "monospaced": design = .monospaced
        default:           design = .default
        }
        return .system(textStyle, design: design)
    }
    
    func canSpend(_ amount: Int) -> Bool {
        amount > 0 && amount <= coinBalance
    }
    
    func spend(_ amount: Int) {
        guard canSpend(amount) else { return }
        coinBalance -= amount
    }
}
