//
//  RoutinePlaybackView.swift
//  Rutinas
//

import SwiftUI
import SwiftData
import Kingfisher

struct RoutinePlaybackView: View {
    @Bindable var routine: Routine
    @EnvironmentObject var user: User
    @Environment(\.dismiss) private var dismiss
    @State private var currentCardIndex: Int = 0
    
    private var sortedFlashcards: [Flashcard] {
        routine.flashcards.sorted { left, right in
            left.index < right.index
        }
    }
    
    private var isLastCard: Bool {
        currentCardIndex == sortedFlashcards.count - 1
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Dismiss
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            Spacer()
            
            // Pictograma
            KFImage(sortedFlashcards[currentCardIndex].imageURL)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 12)
            
            // Text
            Text(sortedFlashcards[currentCardIndex].text)
                .font(.system(.title, design: user.fontDesign).bold())
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            // Progress bar
            ProgressView(value: Double(currentCardIndex + 1),
                         total: Double(sortedFlashcards.count))
            .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
            
            // Buttons
            HStack {
                Spacer()
                
                // Retroceder
                Button {
                    withAnimation {
                        currentCardIndex = max(currentCardIndex - 1, 0)
                    }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                }
                .disabled(currentCardIndex == 0)
                
                Spacer()
                
                // Avanzar / Completar
                Button {
                    if isLastCard {
                        if !Calendar.current.isDateInToday(user.lastStreakDate ?? .distantPast) {
                            user.currentStreak += 1
                            user.lastStreakDate = Date()
                        }
                        user.coinBalance += routine.coinReward
                        routine.lastCompletionDate = Date()
                        dismiss()
                    } else {
                        withAnimation { currentCardIndex += 1 }
                    }
                } label: {
                    VStack {
                        Image(systemName: isLastCard ? "party.popper.fill" : "forward.fill")
                            .font(.largeTitle)
                        if isLastCard {
                            HStack(spacing: 4) {
                                Text("+\(routine.coinReward)")
                                Image(systemName: "sparkles")
                            }
                            .font(.system(.headline, design: user.fontDesign))
                            .foregroundColor(.yellow)
                        }
                    }
                }
                Spacer()
            }
            .frame(height: 60)
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    RoutinePlaybackView(routine: SampleData.shared.routine)
        .environmentObject(User(currentStreak: 10, lastStreakDate: .now, coinBalance: 350, preferredFontDesign: "serif"))
}
