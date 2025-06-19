//
//  RoutineDetailView.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct RoutineDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var user: User = SampleData.shared.user
    
    @Bindable var routine: Routine
    @State private var isShowingEditSheet = false
    @State private var showingDeleteAlert = false
    
    // Sorted list of cards
    private var sortedFlashcards: [Flashcard] {
        routine.flashcards.sorted { $0.index < $1.index }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Header
                VStack {
                    KFImage(routine.coverImageURL)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 1)
                        .padding()
                    
                    Text(routine.title)
                        .font(.title.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.vertical, 4)
                    
                    Text(routine.repetitionDescription)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text("from \(routine.startTime.formatTime()) to \(routine.endTime.formatTime())")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                
                HStack(spacing: 16) {
                    // Delete button
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.red)
                            .padding(16)
                            .background(Color(.secondarySystemFill))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    // Edit button
                    Button {
                        isShowingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.accentColor)
                            .padding(16)
                            .background(Color(.secondarySystemFill))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
                
                // Flashcard list
                ForEach(sortedFlashcards) { flashcard in
                    FlashcardRow(flashcard: flashcard, showIndex: true)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Routine Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingEditSheet) {
            NavigationStack {
                RoutineEditView(routine: routine)
            }
        }
        .alert("Delete Routine", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(routine)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this routine?")
        }
        
    }
}


#Preview {
    NavigationStack {
        RoutineDetailView(routine: SampleData.shared.routine)
    }
}
