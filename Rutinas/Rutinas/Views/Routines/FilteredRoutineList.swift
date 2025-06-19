//
//  FilteredRoutineList.swift
//  Rutinas
//

import SwiftUI

struct FilteredRoutineList: View {
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var didShowAlert = false
    @State private var challengeInput = ""
    @State private var challengeNumber = Int.random(in: 100...999)
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            RoutineListView(titleFilter: searchText)
                .searchable(text: $searchText)
        }
        .onAppear {
            if !didShowAlert {
                didShowAlert = true
                showingAlert = true
            }
        }
        .alert("\(numberToWords(challengeNumber))", isPresented: $showingAlert) {
            TextField("Enter number", text: $challengeInput)
                .keyboardType(.numberPad)
            Button("Submit") {
                if challengeInput == "\(challengeNumber)" {
                    // Challenge passed, can proceed
                } else {
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("To proceed, enter the displayed number.")
        }
    }
    
    // Formarts a number as a string
    private func numberToWords(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

#Preview {
    FilteredRoutineList()
        .modelContainer(SampleData.shared.modelContainer)
}
