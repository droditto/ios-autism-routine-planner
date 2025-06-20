//
//  WeekdayPickerView.swift
//  Rutinas
//

import SwiftUI

struct WeekdayPickerView: View {
    @Binding var selection: Set<Weekday>
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(orderedWeekdays, id: \.self) { day in
                let isOn = selection.contains(day)
                
                Button {
                    toggle(day)
                } label: {
                    Text(day.veryShortName)
                        .bold()
                        .frame(width: 44, height: 44)
                        .background(isOn ? Color.accentColor : Color(.secondarySystemFill))
                        .foregroundColor(isOn ? Color.white : Color.black)
                        .clipShape(Circle())
                }
                .buttonStyle(.borderless)
                
                Spacer()
            }
        }
    }
    
    private var orderedWeekdays: [Weekday] {
        let first = Calendar.current.firstWeekday
        guard let start = Weekday.allCases.firstIndex(where: { $0.rawValue == first }) else {
            return Weekday.allCases
        }
        return Array(Weekday.allCases[start...]) + Array(Weekday.allCases[..<start])
    }
    
    private func toggle(_ day: Weekday) {
        if selection.contains(day) {
            selection.remove(day)
        } else {
            selection.insert(day)
        }
    }
}

#Preview {
    @Previewable @State var selectedDays: Set<Weekday> = [.thursday, .friday]
    WeekdayPickerView(selection: $selectedDays)
}
