//
//  DailyRoutineRowView.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct DailyRoutineRowView: View {
    @Bindable var routine: Routine
    @State private var showPlaybackView = false
    @State private var currentTime: Date = Date()
    @EnvironmentObject var user: User
    
    private var isBeforeStart: Bool {
        currentTime < routine.startTime
    }
    
    private var isCompleted: Bool {
        routine.isCompletedToday()
    }
    
    private var timeOfDaySymbol: String {
        let hour = Calendar.current.component(.hour, from: routine.startTime)
        switch hour {
        case 1..<6:
            return "moon.stars.fill" // Madrugada
        case 6..<12:
            return "sunrise.fill" // Mañana
        case 12..<15:
            return "sun.max.fill"// Mediodía
        case 15..<20:
            return "sunset.fill" // Tarde
        default:
            return "moon.fill" // Noche
        }
    }
    
    var body: some View {
        HStack (spacing: 12) {
            KFImage(routine.coverImageURL)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 70, height: 70)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 1)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(routine.title)
                    .font(.system(.headline, design: user.fontDesign))
                    .lineLimit(2)
                HStack {
                    Image(systemName: timeOfDaySymbol)
                    Text(routine.startTime, style: .time)
                }
                .font(.system(.subheadline, design: user.fontDesign))
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isBeforeStart {
                Image(systemName: "clock")
                    .font(.title)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.secondary)
            } else if isCompleted {
                Image(systemName: "checkmark")
                    .font(.title)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
            } else {
                Button {
                    showPlaybackView = true
                } label: {
                    Image(systemName: "play.fill")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .fullScreenCover(isPresented: $showPlaybackView) {
            NavigationStack {
                RoutinePlaybackView(routine: routine)
            }
        }
        .onAppear {
            currentTime = Date()
        }
    }
}

#Preview {
    List {
        DailyRoutineRowView(routine: SampleData.shared.routine)
            .environmentObject(User(currentStreak: 10, lastStreakDate: .now, coinBalance: 350, preferredFontDesign: "serif"))
    }
}
