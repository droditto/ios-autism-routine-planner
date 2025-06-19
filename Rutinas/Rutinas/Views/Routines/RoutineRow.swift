//
//  RoutineRow.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct RoutineRow: View {
    let routine: Routine
    @State var user: User = SampleData.shared.user
    
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
                    .font(.headline)
                    .lineLimit(1)
                
                // Repetition details
                Text(routine.repetitionDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("from \(routine.startTime.formatTime()) to \(routine.endTime.formatTime())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    List {
        RoutineRow(routine: SampleData.shared.routine)
    }
}
