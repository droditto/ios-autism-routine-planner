//
//  Routine.swift
//  Rutinas
//

import Foundation
import SwiftData

enum Weekday: Int, Codable, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var fullName: String {
        Calendar.current.weekdaySymbols[self.rawValue - 1]
    }
    var shortName: String {
        Calendar.current.shortWeekdaySymbols[self.rawValue - 1]
    }
    var veryShortName: String {
        Calendar.current.veryShortWeekdaySymbols[self.rawValue - 1]
    }
}

@Model
class Routine {
    var id: UUID = UUID()
    var title: String
    var weekdays: Set<Weekday>
    var startTime: Date
    var durationMinutes: Int
    var lastCompletionDate: Date?
    var coverImageURL: URL?
    var coinReward: Int
    
    @Relationship(deleteRule: .cascade)
    var flashcards: [Flashcard]
    
    init(title: String = "", weekdays: Set<Weekday> = [], startTime: Date = Date().nearestHour, durationMinutes: Int = 30, lastCompletionDate: Date? = nil, coverImageURL: URL? = nil, flashcards: [Flashcard] = [], coinReward: Int = 25) {
        self.title = title
        self.weekdays = weekdays
        self.startTime = startTime
        self.durationMinutes = durationMinutes
        self.lastCompletionDate = lastCompletionDate
        self.coverImageURL = coverImageURL
        self.flashcards = flashcards
        self.coinReward = coinReward
    }
    
    func isScheduled(date: Date) -> Bool {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)
        guard let day = Weekday(rawValue: weekdayNumber) else {
            return false
        }
        return weekdays.contains(day)
    }
    
    func isCompletedToday(on date: Date = Date()) -> Bool {
        guard let lastDate = lastCompletionDate else {
            return false
        }
        return Calendar.current.isDateInToday(lastDate)
    }
    
    var endTime: Date {
        guard let end = Calendar.current.date(
            byAdding: .minute,
            value: durationMinutes,
            to: startTime
        ) else {
            return startTime
        }
        return end
    }
    
    var repetitionDescription: String {
        // Si no hay días seleccionados, no hay repetición
        guard !weekdays.isEmpty else { return "No Repetition" }
        
        // Ordenamos los días (1 = sunday, …, 7 = saturday)
        let sortedDays = weekdays.sorted { $0.rawValue < $1.rawValue }
        let rawValues = sortedDays.map { $0.rawValue }
        
        // Casos especiales
        if rawValues.count == 7 {
            return "Every Day"
        }
        if rawValues == [2, 3, 4, 5, 6] {
            return "Weekdays"
        }
        if rawValues == [1, 7] {
            return "Weekends"
        }
        
        // Para un único día, nombre completo. Para varios, versión corta
        let names: [String]
        if sortedDays.count == 1 {
            names = sortedDays.map { $0.fullName }
        } else {
            names = sortedDays.map { $0.shortName }
        }
        
        // Combinar según el número de días
        switch names.count {
        case 0:
            return "No Days Selected"
        case 1:
            return names[0]
        case 2:
            return names.joined(separator: " and ")
        default:
            let allButLast = names.dropLast().joined(separator: ", ")
            return "\(allButLast), and \(names.last!)"
        }
    }
    
    @MainActor
    static let sampleData: [Routine] = [
        Routine(
            title: "Morning Routine",
            weekdays: [.monday, .tuesday, .thursday, .friday, .saturday, .sunday], // Set(Weekday.allCases)
            startTime: Date.time(hour: 7, minute: 0),
            durationMinutes: 30,
            coverImageURL: Pictogram(id: 16711).url,
            flashcards: [
                Flashcard(index: 0, text: "Wake up", imageURL: Pictogram(id: 6027).url),
                Flashcard(index: 1, text: "Get dressed", imageURL: Pictogram(id: 6627).url),
                Flashcard(index: 2, text: "Put on shoes", imageURL: Pictogram(id: 14534).url),
                Flashcard(index: 3, text: "Wash hands", imageURL: Pictogram(id: 2443).url),
                Flashcard(index: 4, text: "Wash face", imageURL: Pictogram(id: 6546).url),
                Flashcard(index: 5, text: "Comb hair", imageURL: Pictogram(id: 26947).url),
            ]
        ),
        
        Routine(
            title: "Breakfast Routine",
            weekdays: Set(Weekday.allCases),
            startTime: Date.time(hour: 8, minute: 0),
            durationMinutes: 120,
            coverImageURL: Pictogram(id: 4626).url,
            flashcards: [
                Flashcard(index: 0, text: "Have breakfast", imageURL: Pictogram(id: 7012).url),
                Flashcard(index: 1, text: "Brush teeth", imageURL: Pictogram(id: 6971).url),
                Flashcard(index: 2, text: "Go to school", imageURL: Pictogram(id: 6454).url),
                Flashcard(index: 3, text: "School activities", imageURL: Pictogram(id: 6624).url),
                Flashcard(index: 4, text: "Enjoy recess", imageURL: Pictogram(id: 2859).url),
                Flashcard(index: 5, text: "Read, paint", imageURL: Pictogram(id: 7141).url),
            ]
        ),
        
        Routine(
            title: "Lunch Break Routine",
            weekdays: Set(Weekday.allCases),
            startTime: Date.time(hour: 12, minute: 0),
            durationMinutes: 120,
            coverImageURL: Pictogram(id: 4611).url,
            flashcards: [
                Flashcard(index: 0, text: "Come back home", imageURL: Pictogram(id: 6964).url),
                Flashcard(index: 1, text: "Wash hands", imageURL: Pictogram(id: 2443).url),
                Flashcard(index: 2, text: "Have lunch", imageURL: Pictogram(id: 6990).url),
                Flashcard(index: 3, text: "Brush teeth", imageURL: Pictogram(id: 6971).url),
                Flashcard(index: 4, text: "Poop", imageURL: Pictogram(id: 16889).url),
                Flashcard(index: 5, text: "Watch TV", imageURL: Pictogram(id: 16905).url),
            ]
        ),
        
        Routine(
            title: "Homework and Playtime Routine",
            weekdays: [.monday, .tuesday, .thursday, .friday, .saturday, .sunday], // Set(Weekday.allCases),
            startTime: Date.time(hour: 15, minute: 0),
            durationMinutes: 120,
            coverImageURL: Pictogram(id: 21943).url,
            flashcards: [
                Flashcard(index: 0, text: "Do homework", imageURL: Pictogram(id: 11228).url),
                Flashcard(index: 1, text: "Have a snack", imageURL: Pictogram(id: 7160).url),
                Flashcard(index: 2, text: "Attend music class", imageURL: Pictogram(id: 6960).url),
                Flashcard(index: 3, text: "Play basketball", imageURL: Pictogram(id: 10166).url),
                Flashcard(index: 4, text: "Play video games", imageURL: Pictogram(id: 10162).url),
                Flashcard(index: 5, text: "Walk the dog", imageURL: Pictogram(id: 9016).url),
            ]
        ),
        
        Routine(
            title: "Bedtime Routine",
            weekdays: Set(Weekday.allCases),
            startTime: Date.time(hour: 20, minute: 0),
            durationMinutes: 90,
            coverImageURL: Pictogram(id: 4592).url,
            flashcards: [
                Flashcard(index: 0, text: "Watch TV", imageURL: Pictogram(id: 16905).url),
                Flashcard(index: 1, text: "Have dinner", imageURL: Pictogram(id: 6970).url),
                Flashcard(index: 2, text: "Go pee", imageURL: Pictogram(id: 37457).url),
                Flashcard(index: 3, text: "Take a shower", imageURL: Pictogram(id: 26803).url),
                Flashcard(index: 4, text: "Read stories", imageURL: Pictogram(id: 6472).url),
                Flashcard(index: 5, text: "Go to sleep", imageURL: Pictogram(id: 6479).url),
            ]
        ),
    ]
}

extension Date {
    static func time(hour: Int, minute: Int, calendar: Calendar = .current) -> Date {
        let today = Date()
        var comps = calendar.dateComponents([.year, .month, .day], from: today)
        comps.hour = hour
        comps.minute = minute
        comps.second = 0
        guard let date = calendar.date(from: comps) else {
            fatalError("No se pudo crear la fecha con hour=\(hour), minute=\(minute)")
        }
        return date
    }
    
    var nearestHour: Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        var hour = comps.hour ?? 0
        if let minute = comps.minute, minute >= 30 {
            hour += 1
        }
        // Ajuste en caso de desbordar más allá de las 23
        var dayComps = calendar.dateComponents([.year, .month, .day], from: self)
        if hour >= 24 {
            hour = 0
            // avanzar un día
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: self) {
                dayComps = calendar.dateComponents([.year, .month, .day], from: nextDay)
            }
        }
        dayComps.hour = hour
        dayComps.minute = 0
        dayComps.second = 0
        guard let date = calendar.date(from: dayComps) else {
            fatalError("No se pudo calcular nearestHour para \(self)")
        }
        return date
    }
    
    func formatTime() -> String {
        struct StaticFormatter {
            static let timeFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = Locale.current
                formatter.dateFormat = "HH:mm"
                return formatter
            }()
        }
        return StaticFormatter.timeFormatter.string(from: self)
    }
}
