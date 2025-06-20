//
//  DailyRoutinesView.swift
//  Rutinas
//

import SwiftUI
import SwiftData

struct DailyRoutinesView: View {
    @Query var routines: [Routine]
    @EnvironmentObject var user: User
    @Environment(\.modelContext) private var modelContext
    @State private var showCoinBalance: Bool = false
    
    var todayRoutines: [Routine] {
        let today = Date()
        
        return routines
            .filter { routine in routine.isScheduled(date: today) }
            .sorted { lhs, rhs in lhs.startTime < rhs.startTime }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if todayRoutines.isEmpty {
                    ContentUnavailableView("No routines today", systemImage: "tray")
                        .padding()
                } else {
                    List(todayRoutines) { routine in
                        DailyRoutineRowView(routine: routine)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Today")
            .toolbar {
                // Settings
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: FilteredRoutineList()) {
                        Image(systemName: "gearshape.2.fill")
                            .foregroundColor(.secondary)
                            .font(.headline)
                    }
                }
                
                // Streak + Coin balance
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Streak
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                        Text("\(user.currentStreak)")
                    }
                    .foregroundColor((user.isStreakRenewedToday) ? .orange : .secondary)
                    .font(.system(.headline, design: user.fontDesign))

                    // Coin balance
                    Button {
                        showCoinBalance.toggle()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                            Text("\(user.coinBalance)")
                        }
                        .foregroundColor(.yellow)
                        .font(.system(.headline, design: user.fontDesign))
                    }
                }
            }
            .sheet(isPresented: $showCoinBalance) {
                CoinBalanceView()
                    .interactiveDismissDisabled()
            }
        }
        .onAppear {
            resetStreakIfNeeded()
        }
    }
    
    private func resetStreakIfNeeded() {
        let cal = Calendar.current
        let todayStart = cal.startOfDay(for: Date())
        
        if let last = user.lastStreakDate {
            let lastStart = cal.startOfDay(for: last)
            let yesterday = cal.date(byAdding: .day, value: -1, to: todayStart)!
            if !cal.isDate(lastStart, inSameDayAs: todayStart)
                && !cal.isDate(lastStart, inSameDayAs: yesterday) {
                user.currentStreak = 0
            }
        } else {
            user.currentStreak = 0
        }
    }
}

#Preview {
    DailyRoutinesView()
        .environmentObject(SampleData.shared.user)
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview ("Empty List") {
    DailyRoutinesView()
        .environmentObject(User(currentStreak: 10, lastStreakDate: .now, coinBalance: 350, preferredFontDesign: "monospaced"))
        .modelContainer(for: [Flashcard.self, Routine.self, User.self], inMemory: true)
}
