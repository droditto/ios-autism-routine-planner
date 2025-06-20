//
//  RoutineList.swift
//  Rutinas
//

import SwiftUI
import SwiftData

struct RoutineListView: View {
    @Query(sort: \Routine.title) var routines: [Routine]
    @EnvironmentObject var user: User
    @Environment(\.modelContext) private var context
    @State private var newRoutine: Routine?
    
    let fontDesigns = ["default", "serif", "rounded", "monospaced"]
    
    init(titleFilter: String = "") {
        let predicate = #Predicate<Routine> { routine in
            titleFilter.isEmpty || routine.title.localizedStandardContains(titleFilter)
        }
        _routines = Query(filter: predicate, sort: \Routine.title)
    }
    
    var body: some View {
        Group {
            if !routines.isEmpty {
                List {
                    ForEach(routines) { routine in
                        NavigationLink(destination: RoutineDetailView(routine: routine)) {
                            RoutineRow(routine: routine)
                        }
                    }
                    .onDelete(perform: deleteRoutines(indexes:))
                }
            } else {
                ContentUnavailableView("No Routines", systemImage: "tray")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Routines")
        .toolbar {
            // Add routine button
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: addRoutine) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor, Color(.secondarySystemFill))
                }
            }
            
            // Font picker
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    // Picker for font design
                    Picker(selection: $user.preferredFontDesign) {
                        ForEach(fontDesigns, id: \.self) { design in
                            Text(design.capitalized).tag(design)
                        }
                    } label: {
                        Text("Font Design")
                        Text(user.preferredFontDesign.capitalized)
                        
                    }
                    .pickerStyle(.menu)
                } label: {
                    Image(systemName: "character.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor, Color(.secondarySystemFill))
                }
            }
        }
        .sheet(item: $newRoutine) { routine in
            NavigationStack {
                RoutineEditView(routine: routine, isNew: true)
            }
            .interactiveDismissDisabled()
        }
    }
    
    // Creates a new routine
    private func addRoutine() {
        let newRoutine = Routine(title: "")
        context.insert(newRoutine)
        self.newRoutine = newRoutine
    }
    
    // Deletes selected routines
    private func deleteRoutines(indexes: IndexSet) {
        for index in indexes {
            context.delete(routines[index])
        }
    }
}

#Preview {
    NavigationStack {
        RoutineListView()
            .environmentObject(SampleData.shared.user)
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty List") {
    NavigationStack {
        RoutineListView()
            .environmentObject(User(currentStreak: 10, lastStreakDate: .now, coinBalance: 350))
            .modelContainer(for: Routine.self, inMemory: true)
    }
}
