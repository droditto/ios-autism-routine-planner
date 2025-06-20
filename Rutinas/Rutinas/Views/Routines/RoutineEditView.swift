//
//  RoutineEditView.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct RoutineEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var routine: Routine
    let isNew: Bool
    
    @State private var showImagePicker: Bool = false
    @State private var editMode  = EditMode.active
    @State private var selection = Set<UUID>()
    @State private var showAddFlashcard = false
    
    init(routine: Routine, isNew: Bool = false) {
        self.routine = routine
        self.isNew = isNew
    }
    
    private var sortedFlashcards: [Flashcard] {
        routine.flashcards.sorted { $0.index < $1.index }
    }
    
    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                // Header
                Section {
                    VStack {
                        Button { showImagePicker = true } label: {
                            ZStack {
                                if let url = routine.coverImageURL {
                                    KFImage(url)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fill)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 1)
                                        .padding(4)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.tertiarySystemFill))
                                    Image(systemName: "camera.circle.fill")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            .frame(width: 180, height: 180)
                        }
                        .buttonStyle(.plain)
                        
                        TextField("Title", text: $routine.title)
                            .font(.title.bold())
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                }
                
                // Repetition
                WeekdayPickerView(selection: $routine.weekdays)
                
                DatePicker("Start time", selection: $routine.startTime, displayedComponents: .hourAndMinute)
                
                Stepper("\(routine.durationMinutes) minutes", value: $routine.durationMinutes, in: 5...180, step: 5)
                
                // Reward
                Stepper("\(routine.coinReward) coins", value: $routine.coinReward, in: 5...100, step: 5)
                
                // Flashcards
                ForEach(sortedFlashcards) { flashcard in
                    FlashcardRow(flashcard: flashcard)
                }
                .onMove(perform: moveFlashcards)
            }
        }
        .listStyle(.plain)
        .environment(\.editMode, $editMode)
        .navigationTitle(isNew ? "New Routine" : "Edit Routine")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Cancel / Add / Done
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if isNew { context.delete(routine) }
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(isNew ? "Add" : "Done") {
                    dismiss()
                }
                .disabled(routine.title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            // Bottom bar
            ToolbarItemGroup(placement: .bottomBar) {
                Button(role: .destructive) {
                    deleteSelectedFlashcards()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selection.isEmpty)
                
                Spacer()
                
                Button {
                    showAddFlashcard = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        // Sheet: elegir cover de rutina
        .sheet(isPresented: $showImagePicker) {
            PictogramPickerView { url in
                routine.coverImageURL = url
                showImagePicker = false
            }
        }
        // Sheet: crear nueva flashcard
        .sheet(isPresented: $showAddFlashcard) {
            FlashcardEditView { text, url in
                // Insertar en SwiftData
                let nextIdx = (routine.flashcards.map { $0.index }.max() ?? -1) + 1
                let card = Flashcard(index: nextIdx, text: text, imageURL: url)
                context.insert(card)
                routine.flashcards.append(card)
                showAddFlashcard = false
            }
        }
    }
    
    func moveFlashcards(from idx: IndexSet, to off: Int) {
        routine.flashcards.move(fromOffsets: idx, toOffset: off)
        for (i, card) in routine.flashcards.enumerated() {
            card.index = i
        }
    }
    
    private func deleteSelectedFlashcards() {
        let toDelete = routine.flashcards.filter { selection.contains($0.id) }
        for card in toDelete {
            context.delete(card)
        }
        routine.flashcards.removeAll { selection.contains($0.id) }
        selection.removeAll()
        for idx in routine.flashcards.indices {
            routine.flashcards[idx].index = idx
        }
    }
}

#Preview {
    NavigationStack {
        RoutineEditView(routine: SampleData.shared.routine)
    }
}

#Preview ("New Routine") {
    @Previewable @State var routine: Routine = Routine()
    NavigationStack {
        RoutineEditView(routine: routine, isNew: true)
    }
}
